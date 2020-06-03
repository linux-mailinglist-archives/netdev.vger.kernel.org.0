Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CACD1EC782
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFCClI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgFCClG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 22:41:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6C3C08C5C0;
        Tue,  2 Jun 2020 19:41:05 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w20so690100pga.6;
        Tue, 02 Jun 2020 19:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EB75bi8QTeVzqrx9jwWk4wz772Z05AX+1WdlpDKhHNo=;
        b=KuoK74s/E/VLnN5y3HutWbMf6OeGxNP0wJfX/55F4KC3WWYexpSFh2oULh0X3AN5OG
         Sr+cKm4gNgdOtHq49ubNwFVqoTWlMjt71bld3no5nn0/UtoJvqfNly9xuhOUegKbFbzo
         4Kzj6UMwi61P11r0NA1CZxvF9OgvJ9SYMeVBDuotcbwmY0sDoRjc1//QZD04MTp38jBw
         8nI8bmh0/edUCJn6qgjKGMjpYh0jJOZ0318fWAYZ9wjHpRXbElhSQy3cRohaVZMaxsrN
         GagaCUCU/EH9j1D3D1VD+a8drJGnjZibKcNwng4SUekB7YAiz8jbEW0+HxjV1T6Qya7w
         kNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EB75bi8QTeVzqrx9jwWk4wz772Z05AX+1WdlpDKhHNo=;
        b=J36EplU+5+YjpCB63Rxyz4UJ7FCDVjo2FhJr9U3S1Dsfe5NHMYipy/I3M696u8q2J6
         YF4DYV1T9BqeL0ZExCowyQ7GnbawAlYGJk2cndQie7fPTlVXAvYLj9XqQI94NsVIfkwx
         RYSIQ0OZMTW+nYLphyMWgy4S/OHFdCPBtgrDcwfWWIqaksCsIkwmYZoQAeFIjW1So8la
         OB1WiwE5A7oksHhM4SqA3qus2hKnxCLAxH3hHYZUzWtmEc6nfTFJc0CgXMkbC16MYULe
         kEfD621qpe2GME4JobOuCGsQXF7FFdqM229z1LsOYfMxOD07qBRhZex2IMjimZJJiaJf
         +5Rg==
X-Gm-Message-State: AOAM533Bv0lQtNDAMJNLkfkLcnvBNaI3Ybe+4mZgLqzrcMxikf/uyWUS
        d2oIhcd86uK0Nn2IVvaR9NQ=
X-Google-Smtp-Source: ABdhPJzRdgif90NB2MPa1c8Oo6UyryMehTj1voTNyEQ50nY1t/+htMLnKqYCILHLu0IG97LXz31GXQ==
X-Received: by 2002:a63:b10b:: with SMTP id r11mr25502461pgf.27.1591152065420;
        Tue, 02 Jun 2020 19:41:05 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 207sm386461pfw.190.2020.06.02.19.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 19:41:04 -0700 (PDT)
Date:   Wed, 3 Jun 2020 10:40:54 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zh9t1xvh.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:21:54PM +0200, Toke Høiland-Jørgensen wrote:
> > The example in patch 2 is functional, but not a lot of effort
> > has been made on performance optimisation. I did a simple test(pkt size 64)
> > with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
> > arrays:
> >
> > bpf_redirect_map() with 1 ingress, 1 egress:
> > generic path: ~1600k pps
> > native path: ~980k pps
> >
> > bpf_redirect_map_multi() with 1 ingress, 3 egress:
> > generic path: ~600k pps
> > native path: ~480k pps
> >
> > bpf_redirect_map_multi() with 1 ingress, 9 egress:
> > generic path: ~125k pps
> > native path: ~100k pps
> >
> > The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> > the arrays and do clone skb/xdpf. The native path is slower than generic
> > path as we send skbs by pktgen. So the result looks reasonable.
> 
> How are you running these tests? Still on virtual devices? We really
> need results from a physical setup in native mode to assess the impact
> on the native-XDP fast path. The numbers above don't tell much in this
> regard. I'd also like to see a before/after patch for straight
> bpf_redirect_map(), since you're messing with the fast path, and we want
> to make sure it's not causing a performance regression for regular
> redirect.
> 
> Finally, since the overhead seems to be quite substantial: A comparison
> with a regular network stack bridge might make sense? After all we also
> want to make sure it's a performance win over that :)

Hi Toke,

Here is the result I tested with 2 i40e 10G ports on physical machine.
The pktgen pkt_size is 64.

Bridge forwarding(I use sample/bpf/xdp1 to count the PPS, so there are two modes data):
generic mode: 1.32M PPS
driver mode: 1.66M PPS

xdp_redirect_map:
generic mode: 1.88M PPS
driver mode: 2.74M PPS

xdp_redirect_map_multi:
generic mode: 1.38M PPS
driver mode: 2.73M PPS

So what do you think about the data. If you are OK, I will update
my patch and re-post it.

Thanks
Hangbin
