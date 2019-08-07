Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D8385267
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfHGRwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:52:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40382 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbfHGRwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:52:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so41839396pla.7;
        Wed, 07 Aug 2019 10:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2w6qnPqfEtgM9+YBuDuC0JptFP8LJDMU9xRlYYxH/U8=;
        b=KmbW9eZT8JulV7C3R7Pn8J+fWAX0DMla2AewSko+exDWz4VCtXwh45Arg+Oh5dtdT/
         DfzcsWodtgs/tMSneOrucfvVVmAJOO3brB3EPowVH728w4ZEyvnGegXbMA3vSxQ8S0Aa
         +2Kw0hGykHO1nuMPunAAoeKUO3y0g9hd9jMKGLEL9Orm769WEdwoy5RaEmKO6T9sVP51
         ShWT6tyOIkV2/BB1fDzoS+BovVun1qzB63k/w2Btm6KFaZUcF6NzFEeAYLMRYnqLIt40
         MuRyHGPoEmKUHolv2Nn3r75hnk3qSNQJ+nQ/jw6SaemVn0G03JdYcRsMcOYGi4FnVlRI
         4Osw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2w6qnPqfEtgM9+YBuDuC0JptFP8LJDMU9xRlYYxH/U8=;
        b=omFEnqeyuFQAzH6q9Sp2pxgXVkJACI60lBWT42GVYHFfgmmd7xwZ/KSWdhILQUG6xT
         74DAoWNipOHvh9If5zxAyuN9nrJbBrKQUy+Qw6V9hIl9jGPnzgweG9U7kQr192YLdygZ
         ATDiLPfl5WNgzTZzGWyiRR7EcFZ1osz7RYSygtSQE1H4CXUZhrU+3S6LM6pnc6wlONQk
         uKZ7o/6vwe8Wx2oyyhxHKy1NZD45GrjoozJP0SjZ1yuy0OmSKcIqkBsaPZ1HjaloIIcP
         FeTv2PxiFsfk/eJlA3bkAIsqrNWtT4CfP2ahWLzuSdOO+xSO5R3j/tvCCXILuJI+RrM7
         otcg==
X-Gm-Message-State: APjAAAVJNOTvCb0cCn+UQQYAHJwJsXmi6RMJUhk0YZzbD7w39ehWygUI
        RNJt7inPy3o+G2CdE/ICXj8=
X-Google-Smtp-Source: APXvYqwUl/pxU0riqzhUTQYqTny0H9EZLvjHE6tEXrbJuiEpnl9wQzN3m2GasBhTrVU1+cz/0KbZEA==
X-Received: by 2002:aa7:9531:: with SMTP id c17mr10972312pfp.130.1565200356483;
        Wed, 07 Aug 2019 10:52:36 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id q144sm92988568pfc.103.2019.08.07.10.52.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:52:35 -0700 (PDT)
Subject: Re: [bpf-next PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to
 be xdp_tx_ports
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <156518137803.5636.11766023213864836956.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d687330-8689-2974-8ed0-7bcb61038c80@gmail.com>
Date:   Wed, 7 Aug 2019 11:52:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <156518137803.5636.11766023213864836956.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 6:36 AM, Jesper Dangaard Brouer wrote:
> The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
> which only have a single TX port. Change name to xdp_tx_ports
> to make it more descriptive.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_fwd_kern.c |    5 +++--
>  samples/bpf/xdp_fwd_user.c |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
Reviewed-by: David Ahern <dsahern@gmail.com>


