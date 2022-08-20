Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28DF59A9D6
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbiHTAHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244652AbiHTAH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:07:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8C2108F1B;
        Fri, 19 Aug 2022 17:07:29 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso8953185pjk.0;
        Fri, 19 Aug 2022 17:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=0hmuTElgj7SfGWCQGn41b6TzMA7sA0gx+Z8F66YiYzY=;
        b=A0ZtnnvDawbUdSk2r18tYNNarixMK2XD8L7q2AV8j2vx0Mq1UrslI8gt8PtMK3dSGe
         wZbTts8tayz9q0+CLqdJf4wh40w5sKYrl3Vks7EMH6A4cnYBO1QF0OTUmr9pdhqkpNmx
         pONk44DzrYb5ujw1g/UNAoXzR12IHKGoU50IjXIUP4hL3iZwodhZ/KtBRTk7k4QJSAKp
         2pi3laSD+KKQNCFH9fAKyuQFMmEIaY7lal/1+fSFn4SLCSsoI6WdtHRyXunBeo0lmDxx
         P2g/5NNOrP2zaz3h3wim0+6KHupePCrtnrNaxV2wt6GGmx7nL3wK4/Il2vtNsu4y8mrb
         bkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=0hmuTElgj7SfGWCQGn41b6TzMA7sA0gx+Z8F66YiYzY=;
        b=NtKqyTvRmXpHGUX/cvvqhzxpXTXuegvNrPXIXJRHZGwAMC+W+inygSokt0blZwJng8
         2mcCFi1hUE91UPrhz5Ho+pYg1BrSS65KSYXlGMHF5300cmGDz1kcZuKnE5b15oDukI7L
         iZrmL8e8WfKyguSdrpfRe+GuZjWuB6uFICK40f390+x/KRQGfLOmAWB+y387pgq4skbq
         axZAfoB96EGjWetsN5ZNMB+0OLJoQL6rLhOFeH2c+E3OhaLl7g80WFQevwP9EAUjAn2Z
         93MwDeF3VEy+iMw/q26Pk3bvoslrUsKLJabITZMbavyl4pWnilHrqbTfq/yqS315zr2k
         jxJg==
X-Gm-Message-State: ACgBeo3HktX7D1/lW+emqOhTapS2SjrRRvUgq2PA52m3a8Ik1DSpoEpL
        iAFUZt1gVCKSKAftlQ/7L3I=
X-Google-Smtp-Source: AA6agR44+AZahQaWOEndohvIoUdMjDkyhpmDenr7SvGCnvrstDMedKcYM24510FzKzI4/dPGQBy3wg==
X-Received: by 2002:a17:90a:db95:b0:1fa:c02b:5e34 with SMTP id h21-20020a17090adb9500b001fac02b5e34mr10961714pjv.159.1660954048438;
        Fri, 19 Aug 2022 17:07:28 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:a2f5])
        by smtp.gmail.com with ESMTPSA id d8-20020a170903230800b0016dc6279ab8sm3753902plh.159.2022.08.19.17.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 17:07:27 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 19 Aug 2022 14:07:26 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xin Gao <gaoxin@cdjrlc.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, sdf@google.com,
        daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core: Variable type completion
Message-ID: <YwAlvv+xf//wlTSg@slm.duckdns.org>
References: <20220817013529.10535-1-gaoxin@cdjrlc.com>
 <20220819164731.22c8a3d2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819164731.22c8a3d2@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 04:47:31PM -0700, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 09:35:29 +0800 Xin Gao wrote:
> > 'unsigned int' is better than 'unsigned'.
> 
> Please resend with the following subject:
> 
> [PATCH net-next] net: cgroup: complete unsigned type name

Out of curiosity, why is 'unsigned int' better than 'unsigned'?

Thanks.

-- 
tejun
