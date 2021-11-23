Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D535B45B040
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhKWXhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhKWXhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 18:37:41 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF776C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 15:34:32 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so1293915otv.9
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 15:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZALux30ukNf/FhcJ+79TogdOyRf2h5T5OprayLBEQHY=;
        b=O1FUakhvf22Yu9U3LbS+qd8akMYeMYyefKF1DljHabWxsg5yi1fIZ9zEnOqrTpOiu9
         GOowC8+0TyEBoOGkIOGvRWWzy8YdMu8itt4T0W+q/0ILS876gjxq9i+NOEqdl6HmqiR8
         QCDpuWKXw4+xmagI9smDLgskJmfuMaV2Nnlr+0OWPjV8h8P0JOlDUf7naYJPiqUGEMbq
         c7MDewBN42Amj7eVlozlMNhRPKycI+7Frwp8GCdkHmtORrY8OpZmFe2Xdar97D/FTq9s
         XBky+s9o7cPtxBFwLOJZ73AxN1s5HmI2/M4omeAU9Oivj7lDGrhTeO1zUe2swW+IL1Pm
         mcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZALux30ukNf/FhcJ+79TogdOyRf2h5T5OprayLBEQHY=;
        b=RuQVihYnE0sEJbUqaTGZyZPzenveY4ihKwKkmPRYO3V1ZRi4UEb1R51y6kqZzoJVYi
         8uhkFwzus+3vVymswM3PgSER0XIKldKKUQu9MCbd5enI8RoEiEo8dv+5UZEYxsX5uVSg
         F1PX/PF1oFTXKPaZly4yEy6edcQO9bQeEFWFk2j7skS6Lvf4xJCmFpWqT8zoa8Ko8Uri
         Ww0mCKZKxlanH9IBWHrVJ5O/Ioamx9eVyd0LX01Qe5LbyJXfgjwG5+7XBMMZhZS8Z4VX
         e72C6tn0LU3mutB/twE4XZNeb/GFEAknJAYF5O9akW2vNTRYh6yrlxOYb8Vn/fUsUeFV
         rpAw==
X-Gm-Message-State: AOAM532kvPXvS4yyXwbYagFj7ASICxN46kwPa9/96bnTyp4u8KeHb/x1
        2MgxAzXSZwABz5shOkNmxQE=
X-Google-Smtp-Source: ABdhPJyZYEmy8rpn+9Niu/OdL6fOrIINfei8hOqAod7/ABcmByRNO9n+BCsbuR0SWWGZp8aTccarEQ==
X-Received: by 2002:a9d:12f3:: with SMTP id g106mr8342463otg.175.1637710472317;
        Tue, 23 Nov 2021 15:34:32 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:ed62:84b1:6aa6:3403])
        by smtp.gmail.com with ESMTPSA id a3sm2415085oti.29.2021.11.23.15.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 15:34:31 -0800 (PST)
Date:   Tue, 23 Nov 2021 15:34:30 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        vladbu@nvidia.com
Subject: Re: [PATCH net-next  1/1] tc-testing: Add link for reviews with TC
 MAINTAINERS
Message-ID: <YZ16hnd71IMjJE4z@unknown>
References: <20211122144252.25156-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122144252.25156-1-jhs@emojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 09:42:52AM -0500, Jamal Hadi Salim wrote:
> From: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
