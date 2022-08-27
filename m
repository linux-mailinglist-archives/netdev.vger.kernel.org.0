Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97B35A3996
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiH0Sqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH0Sqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:46:46 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AE232EE1;
        Sat, 27 Aug 2022 11:46:45 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id q6-20020a4aa886000000b0044b06d0c453so815875oom.11;
        Sat, 27 Aug 2022 11:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=69+9gp7OFZSr9PPlljFw2OoKkVTL805qaZz+wfhp7oE=;
        b=FKmBCoanyLT9A3oyRzBhuDxYdYCnqYBTHQXyvl/xpyJmIkeCg+6zyc3zYSwh2hbIdT
         NyiYi7exxe3mGWPjYDo5Ili+qJ+kR0wgbODstFsSnWIlFyS6+9uc96QvesS5sJxmwUgt
         GNrw2b1x42ir6Qb+UFozrgytX2ohWrolzAV33B7ILthqOPGuEjp/7tmE7C5DPEdvRDjx
         y/LZrCri/lPNtUznMdq700hcm3DDObDieBqq86+9KzlQEvUGdKM7eE+JPi5Mw0+5mPf1
         x+3FIbowAOSVOvxTQQeyU1gs3e3X0Pgs/K080gyYTPiH5rjh06znOupaHO5Tbrz/vawU
         PSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=69+9gp7OFZSr9PPlljFw2OoKkVTL805qaZz+wfhp7oE=;
        b=axQ717iKlQLr5m/mjl9Fkwcv9lXPKw/A3Jiv0igmm7xOfn2wqJwaA095/Gf8a4pbty
         bj5qn6mUPcEpBwWc+HyHOMtbtbpl1gWcKu+Qn8osoz68HsANfzAEr/CP9gGl6M9xzWOV
         9tEPo9BIpY3YlXrMr8JcSMj+AvNzcxsQxUTgI1Rej9cCEtKaPoXQcBflo0WMSLda2rmA
         t6EMmS0X1QfCbSjMlUkX1rWkYhhy6T8o2z05IuvDjr2JKUBQFwlitA0u97NYypcRa4/K
         62tjx/WtRH9vFTBCqhwOk8ApUclww8SD6TmfXYGmNcRsaAvfgfi4Jxe4/AYVDHS2J9GH
         gzBw==
X-Gm-Message-State: ACgBeo0hgZLxkxFheTdGfAvQ84otb7hFMjEt6SiKx+Ce7BOhREHFVBGT
        7rraL1mgJJsCQ2PonT+9kOjrE6gmTAo=
X-Google-Smtp-Source: AA6agR6qQnRexHuuxr8v6XkFJY/ed/0nN8p2CRauEFit5/0GJn6iFdKafGA+pw22J57PW6GlRvq+Lg==
X-Received: by 2002:a4a:334f:0:b0:44b:460b:9a27 with SMTP id q76-20020a4a334f000000b0044b460b9a27mr3165846ooq.46.1661626004881;
        Sat, 27 Aug 2022 11:46:44 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:e448:c1ce:ae49:d00c])
        by smtp.gmail.com with ESMTPSA id c24-20020a4ad8d8000000b00435b646f160sm2801038oov.5.2022.08.27.11.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 11:46:44 -0700 (PDT)
Date:   Sat, 27 Aug 2022 11:46:43 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, jiri@resnulli.us, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net-next] net: sched: red: remove unused input parameter
 in red_get_flags()
Message-ID: <Ywpmky1B0oh+KQgU@pop-os.localdomain>
References: <20220827043545.248535-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827043545.248535-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 12:35:45PM +0800, Zhengchao Shao wrote:
> The input parameter supported_mask is unused in red_get_flags().
> Remove it.
> 

It looks like this is incomplete code unification of the following
commit:

commit 14bc175d9c885c86239de3d730eea85ad67bfe7b
Author: Petr Machata <petrm@mellanox.com>
Date:   Fri Mar 13 01:10:56 2020 +0200

    net: sched: Allow extending set of supported RED flags

How about completing it? ;)

Thanks.
