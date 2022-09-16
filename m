Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB35BB452
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiIPWN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiIPWNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:13:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9BEBBA71
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 15:13:51 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s206so21582784pgs.3
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 15:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=worldwidemarketdata.com; s=google;
        h=thread-index:content-language:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:to:from
         :from:to:cc:subject:date;
        bh=r7aZyyleLHjXdGdlkJWYkfL2PvY4y1yGX/Jdwf9NK1Q=;
        b=GtYBAZw10k5rJS+lKTrAebzybQZABuv8CViS3UzphYauetc4MI56sDTOI1U45ES30d
         ey72Bxsu1j+huS+GAdMeMsoXf0laH0ojXpzWWrRfw6MfIYHkruUObXjHL1SHh4fEc4CS
         FMyPr4Ph/tqnMGPfXKhpud2pkZ7+/Gqpl/ylScl6pNfsrYv/CkZkP1Ibys7qgqAtcz11
         OW+DhcvWYHmJ9+T0jL5kRjdZkdmvGjgbQMC9PLUSpUMSZnXAQgrCc5FokqX8uM5o9vhr
         04BXKahs4VIXHaWTGxwa+gBnkabuo+jJF5zbRe5j7nMTQVxqYqqMZRBetyXCQOLbLcs5
         CL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=thread-index:content-language:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=r7aZyyleLHjXdGdlkJWYkfL2PvY4y1yGX/Jdwf9NK1Q=;
        b=SkqEK9VqBsDIWbeoza2PgWl1Z8+cFaNH8sjKhaKNF8p/8zKuqPdIJ2qdpZOJlCXKXr
         Am+zhtaXOpVQe36dOzjCt+EHzCN/7nHSqfKC6tSplF35LDQkckX3fBmPpA3XVyMN1svb
         h84MrFjQml4z2+ApUYzQ4x6NCJn+9xtpGtmuPfxhKmrGDQ21Yt/sYWrr1c2gHfvYXh+g
         3EFdLByV2eP2WGQENkfEEJgIEw0kyYLyzf72SAJ0YmhDdXa6VQ3nnl78RffV7LLwPh8s
         hr+1hGzlwF3xZewzG97Gw9PCEYQWUKHd0+/rTTguq1NSy+hCrE1CV3vZ79TFyuEWZa3V
         eq4Q==
X-Gm-Message-State: ACrzQf0/dAe8v380+on8sOvWV0LPkxVIUyAaVkJijEvFfPzWVsi1t/hj
        AK+wnDB8uvHh5IHNTtjVYPOf1Q==
X-Google-Smtp-Source: AMsMyM7CNQxWEuvJBOwEzNtIq76NfEh+zKMKWckRrwzAgVdY/Um7Ipe6m9zgY+aDeKT+lXaQSDeDQA==
X-Received: by 2002:a63:1605:0:b0:434:4748:44bd with SMTP id w5-20020a631605000000b00434474844bdmr6285321pgl.470.1663366431241;
        Fri, 16 Sep 2022 15:13:51 -0700 (PDT)
Received: from DESKTOPR3SMN2M ([49.207.231.67])
        by smtp.gmail.com with ESMTPSA id y6-20020aa79e06000000b00540a346477csm14987107pfq.76.2022.09.16.15.13.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Sep 2022 15:13:49 -0700 (PDT)
From:   "Martha Terry" <martha@worldwidemarketdata.com>
To:     <martha@worldwidemarketdata.com>
References: 
In-Reply-To: 
Subject: RE: IBC Attendees Email List
Date:   Fri, 16 Sep 2022 17:10:46 -0500
Message-ID: <a10601d8ca19$9843e850$c8cbb8f0$@worldwidemarketdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-Language: en-us
Thread-Index: AdjKF1e/ejYE1jwrTQ2QN7eRjkze8AAAAHDQAAAAESAAAAAM4AAAAAoQAAAACUAAAAAHEAAAAAigAAAACkAAAAAQoA==
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I hope you're doing great and staying healthy!

Would you be interested in acquiring IBC Attendees Data List 2022?

List contains: Company Name, Contact Name, First Name, Middle Name, Last
Name, Title, Address, Street, City, Zip code, State, Country, Telephone,
Email address and more,

No of Contacts:- 35,028
Cost: $ 1,881

Looking forward for your response,

Kind Regards,
Martha Terry
Marketing Coordinator

