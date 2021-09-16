Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE88740D411
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhIPHuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234805AbhIPHug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 03:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631778556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UWyWiu8lmLKSnwT/n684r2szfzzyT+xXhGueBd2kHG8=;
        b=T3I0Fco2ApAUJLUX3A1RM6p52KKr52MklRVZB8wtxJoWJaCQr0eRsx1RdmEpJzIGJ24pz9
        OTCW3MESb4PtYocf4hi4ysKb7r9rnjRgQ4OQhvZmDZNNpoJd5QQfkXVSBRwwE4nEUdt6M2
        efOh1T4AKz+E2Roub/XHUgou7h3B4oc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-vjUL0EE_OuiNgjhK7ZvTmQ-1; Thu, 16 Sep 2021 03:49:14 -0400
X-MC-Unique: vjUL0EE_OuiNgjhK7ZvTmQ-1
Received: by mail-lf1-f69.google.com with SMTP id p3-20020a0565121383b0290384997a48fcso3134237lfa.21
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 00:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UWyWiu8lmLKSnwT/n684r2szfzzyT+xXhGueBd2kHG8=;
        b=WDDV9L0CjZn+VQgjs8GjkX22MsW6J39p7ONzH5yt7Dr3tgTEduQIB3iJDl28nJCRWm
         Gh7jwA+jAUJkC2CtmBgHFlczGAL9zFgjBHpg7QfMQIT2Jis5h6p6/b6xWdTUJFusMiZ1
         xhjI7KLo6TyqfddCNbj9rWGP+EodssP4Y1GtNBZL4Jv69D6CN+6Va4lPHQqefO8D1yoh
         m8BoSOr4IqgaX8R7TbhCiwe/VDe4T3HsX/I3sy1i1Liz2i8Xaij6yu6q7b8KdzZnJ1eg
         q6PaOFqzRGz09JoxmSMyvHdo9DiBfmdPxPb7A+rcfg7F/VbHkoRA4fRLRYVI1vEI7qEh
         TeVg==
X-Gm-Message-State: AOAM533Vuw8m45ByyNBLC6zwWOKI6rYo81mwQLSOMed7S7pNzj/5rJ3O
        Rj2lccxODwTjSacHpMnsvp+8xJgzr4866X5zegWB7pP5E0/Xyew/+nhf4A5G2iojWKrntdGDlfr
        wutmB31BQVVRi8WTw
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr3905647ljg.181.1631778552916;
        Thu, 16 Sep 2021 00:49:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDeXtKHmd9q3QVtiFXQb9vFArgWBjssBwLZCdGeI3Fk+2GVhuxaxjEVzS7LvgE8/e5kwGs6w==
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr3905632ljg.181.1631778552733;
        Thu, 16 Sep 2021 00:49:12 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id l2sm190193lfe.1.2021.09.16.00.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 00:49:12 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
Message-ID: <0d82359a-067b-b590-ae19-d360ccc7c0dd@redhat.com>
Date:   Thu, 16 Sep 2021 09:49:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/09/2021 05.21, Alexei Starovoitov wrote:
> From: Alexei Starovoitov<ast@kernel.org>
>
> Document and clarify BPF licensing.
>
> Signed-off-by: Alexei Starovoitov<ast@kernel.org>
> Acked-by: Toke Høiland-Jørgensen<toke@redhat.com>
> Acked-by: Daniel Borkmann<daniel@iogearbox.net>
> Acked-by: Joe Stringer<joe@cilium.io>
> Acked-by: Lorenz Bauer<lmb@cloudflare.com>
> Acked-by: Dave Thaler<dthaler@microsoft.com>
> ---
>   Documentation/bpf/bpf_licensing.rst | 91 +++++++++++++++++++++++++++++
>   1 file changed, 91 insertions(+)
>   create mode 100644 Documentation/bpf/bpf_licensing.rst


Thanks for working on this, it is good this gets clarified.


Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

