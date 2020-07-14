Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DAB21F7EE
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgGNRNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgGNRND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 13:13:03 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE19C061755;
        Tue, 14 Jul 2020 10:13:03 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id m9so7823326qvx.5;
        Tue, 14 Jul 2020 10:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oEwbEZmmMplrJMjtr32ilU+MCxmNJLm4YVuwHz06SaY=;
        b=hXadNisK0AJPFH7jzq5PuL2KcGPHNc5CXKCoLib3hmD3ZjZSdNr0/a5que3nWuF8jB
         ohZokRfNT/xI8PohewiA/sLX+m+ZwuO+HvbA1jEJ+Ie0j5iHxEQvos+Yc7EsrgNJZiVF
         NrcZaYplPV1A2QbHCp+HhESlOcMri/F6lLQ4T1cZOSQqDDKTOHWpZEiBgRafCqVQum+p
         rwBgXC+tVZkdgnnuLJ2YihX7z9bqKfx2FSRWlYo7jI8w2XBIVpMuJ8mg+jPFNG9X8T0t
         49hWhtOvSPUdU4xDSLDk2hK5M8g+5P47sgbdF11Gqr14uLTC7b4dxU/Yr3DKx1KSZZEQ
         JhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oEwbEZmmMplrJMjtr32ilU+MCxmNJLm4YVuwHz06SaY=;
        b=uZuDPR4CVWpFwP4mC7nLzI34m1OlA9WbcP42LtMf9po6KstH2yPvHVEr8xS0oASBT4
         cKXP0s5iDV/ZI1b16OQjLPGFZpDOE2pt5viheZ7TlD0jtSCT+27Jo4D7fIEGnWrmzVPo
         yKresfnfFC40e/tfwc/GigsheWLPh2yl7D+s+Om7q0aeX1XAOXmFXpqYWIFD8UFKhkue
         BvhfFmKNzSxktiSrwoQuEvRsuBrOO7XbiUTGuO45xNx8XJOgN3ViujLg/iAEJlvZYyUK
         p0RMQaFq/+zF/+2WBTAr9Uk7xNC0gpnGNly4UUK1zZ37bL9Xu9tnjK51tB6Nn17nCBDa
         YTUA==
X-Gm-Message-State: AOAM533P6LijXKxjk0DZ/laSGLDVskxYZn6/ELcr/riRAP3HI6ciFQrG
        DTTckKKADGgK+AeTFu9Wq9HGYqyo
X-Google-Smtp-Source: ABdhPJzjwN3ch/0ZCNnVZEWt5NpP3z5/OyPy8ZXtyNXX270dnETkNvdQ/nGi7CmHo2lJz/v4csSg1w==
X-Received: by 2002:a0c:83a5:: with SMTP id k34mr5578861qva.130.1594746782284;
        Tue, 14 Jul 2020 10:13:02 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3884:8f6d:6353:cafd? ([2601:282:803:7700:3884:8f6d:6353:cafd])
        by smtp.googlemail.com with ESMTPSA id 130sm23459173qkn.82.2020.07.14.10.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 10:13:01 -0700 (PDT)
Subject: Re: [PATCHv7 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200714063257.1694964-1-liuhangbin@gmail.com> <87imeqgtzy.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2941a6f5-8c6c-6338-2cea-f3d429a06133@gmail.com>
Date:   Tue, 14 Jul 2020 11:12:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87imeqgtzy.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/20 6:29 AM, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
>> This patch is for xdp multicast support. which has been discussed before[0],
>> The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
>> a software switch that can forward XDP frames to multiple ports.
>>
>> To achieve this, an application needs to specify a group of interfaces
>> to forward a packet to. It is also common to want to exclude one or more
>> physical interfaces from the forwarding operation - e.g., to forward a
>> packet to all interfaces in the multicast group except the interface it
>> arrived on. While this could be done simply by adding more groups, this
>> quickly leads to a combinatorial explosion in the number of groups an
>> application has to maintain.
>>
>> To avoid the combinatorial explosion, we propose to include the ability
>> to specify an "exclude group" as part of the forwarding operation. This
>> needs to be a group (instead of just a single port index), because there
>> may have multi interfaces you want to exclude.
>>
>> Thus, the logical forwarding operation becomes a "set difference"
>> operation, i.e. "forward to all ports in group A that are not also in
>> group B". This series implements such an operation using device maps to
>> represent the groups. This means that the XDP program specifies two
>> device maps, one containing the list of netdevs to redirect to, and the
>> other containing the exclude list.
>>
>> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
>> to accept two maps, the forwarding map and exclude map. If user
>> don't want to use exclude map and just want simply stop redirecting back
>> to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.
>>
>> The 2nd and 3rd patches are for usage sample and testing purpose, so there
>> is no effort has been made on performance optimisation. I did same tests
>> with pktgen(pkt size 64) to compire with xdp_redirect_map(). Here is the
>> test result(the veth peer has a dummy xdp program with XDP_DROP directly):
>>
>> Version         | Test                                   | Native | Generic
>> 5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
>> 5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1.6M
>> 5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
>> 5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1.6M
>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1.5M
>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1.3M
>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.98M
>>
>> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
>> the arrays and do clone skb/xdpf. The native path is slower than generic
>> path as we send skbs by pktgen. So the result looks reasonable.
>>
>> Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
>> suggestions and help on implementation.
>>
>> [0] https://xdp-project.net/#Handling-multicast
>>
>> v7: Fix helper flag check
>>     Limit the *ex_map* to use DEVMAP_HASH only and update function
>>     dev_in_exclude_map() to get better performance.
> 
> Did it help? The performance numbers in the table above are the same as
> in v6...
> 

If there is only 1 entry in the exclude map, then the numbers should be
about the same.
