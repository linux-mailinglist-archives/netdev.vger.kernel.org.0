Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77A84D2F1B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiCIMfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiCIMfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:35:03 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD85142365
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 04:34:04 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bt26so3494650lfb.3
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 04:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=6txNCeY7AWJJpx/yE4XWczovluzseEoRTqfdbPHgl6Y=;
        b=WGpR67gBQ8gAU2eCmA4H7YDUVHMf394plNC9HCqxgWGuclZO6jI6O0pa0RQPWzCmSJ
         DtnC6SqZzEGeIaiJGkcL8hNnizVSHOYP8dj/jxqkYnJkDujsjDLgcy18JZIkvyDkRjpO
         OaEWXhnK6kYy0JsGTIOOrEtivNm5lyWqbZ5mY/t/aU14qEjsQj8BlC3zmXoAFyhc5vNn
         vy/cekghDxvoSBPNnTeou369ZWTL+Ov4NOK1jM8Mecd4o/2bAVektJa9Oa6jHCbyXSxC
         Xa29ueJS02RYH9ax+OnQ7/iS70BEShlveZWUSQenHpoGjqbLXz+rfh5nHAzoq9PKmmpe
         mIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6txNCeY7AWJJpx/yE4XWczovluzseEoRTqfdbPHgl6Y=;
        b=zB3GVCBDhlq6WfQ6zMeuy02ZHGsDVZ2kS6DCeoN+4sIKVshjQYeaZqgeYAc8ZNyImK
         PdGcX7YMShX5NHhBj1lx0SlkEFduC1JPelPwq4ULtf4Q4I66alrBqMNwS8/IyPbuOncu
         6lq7oiJZ05zsiOw4PUPC/bOHVM+Q0SF4hXYLWWsvUmOcUBVkzWR1+8Uf8n54zKcRbxZt
         z2/hvoNtGD9vCsXXxq46CWoz/scFAO+ANLifhADL39U9RJ8QLkVhD7RY061i/wjpendi
         6k6x8DyMnmexnRJ+ePtYfeSHgLHFFmMo2ImO58fekV5PpIXiL5u1X1ruwZIZngJbEYJD
         Mi5w==
X-Gm-Message-State: AOAM532cl/P3xIAO01zFbrEpD0mtcjytUe99acJciAHfm4ZgzBcETCCw
        8PgRGXcsdGOmh6pRO/xfr3o=
X-Google-Smtp-Source: ABdhPJzn4+UXKrM7+vL+Pv0MFk6bNHRLfGxgmEA6RxlhfVpkZov/D/wPojyqYN7IB0hn20yeH6/OBA==
X-Received: by 2002:a05:6512:3d05:b0:448:39b8:d5ef with SMTP id d5-20020a0565123d0500b0044839b8d5efmr6153811lfv.595.1646829242705;
        Wed, 09 Mar 2022 04:34:02 -0800 (PST)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id m12-20020a056512114c00b00443ffe02a1fsm373716lfg.281.2022.03.09.04.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 04:34:01 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2-next v2 4/6] man: ip-link: document new bcast_flood flag on bridge ports
In-Reply-To: <20220308232812.5dc9e7f5@hermes.local>
References: <20220309071716.2678952-1-troglobit@gmail.com> <20220309071716.2678952-5-troglobit@gmail.com> <20220308232812.5dc9e7f5@hermes.local>
Date:   Wed, 09 Mar 2022 13:34:01 +0100
Message-ID: <875yon9ufa.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 23:28, Stephen Hemminger <stephen@networkplumber.org> wrote:
> Minor nit, would be better to put options in alphabetical order in document.
> Certainly not splitting the two mcast options.

Ah, of course!  I'll fix it up in a v3 later today, thanks!

 /J
 
