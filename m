Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7920C0AF
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgF0KVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgF0KVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:21:37 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9C7C03E979;
        Sat, 27 Jun 2020 03:21:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e18so6118939pgn.7;
        Sat, 27 Jun 2020 03:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tW07XZiC9CEEWw6VcmU9nAkZCHxzclaGfw7X0IosT68=;
        b=hS263lqByHbO7EYkzC8PMkEf1Zra+GukflOKzTVKlMAAmYsEImhAl6R5zhjVE4uJ54
         59OgbvfmjJDVYGXAI2kbEczUHHuDoqJBso3wk1aw3DubX9tqf6sJFRL080s1+QHSz3+3
         d5W/dZatNIQe2XxF74qw4mOLqUiQkxpEzSrfq4hH4EGSDZbFrCXVSK3hQnt2LB74B54U
         ZDIQM0v9LNkGOJXveWjbw9EohiRV2jgIRk14IJxT1sX7l58v88p57bb+RH1WHGwYSTIF
         /mVmNOk/DNfwFtsYqp0b9KXyRfHi4hXAAQlLH8kNlFkIT9jNAVYEM89e5X2aVZZzCFxo
         1QsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tW07XZiC9CEEWw6VcmU9nAkZCHxzclaGfw7X0IosT68=;
        b=sDI4VevdMsA3fjbD/ryoxj3rBssdDk0T7AJp/pXA69pT+eutRGWbiMKvKeLuWD9dO/
         TxPoJv8Luo4YVK8e0EvaS6AAs24ueZAXfSw6hLe1565LWfes0pSJgLo1kMjL0hjmJIbg
         5FTXxlx6qYYLqyKboDyQPKUM+6w3CBpXF8kbo/qB0xlAECCLJlUjJDMySqmpg9PZzbqu
         jVu/htI8dC75j4y527je2J90R+seB/jUI/fcETSn87QpB3SKNIqKyIwmCzVi7+ts0NxJ
         4109FfkPTp3qnIOvRgy4sS/V2d93Y0WcrWogdqI8GazROkYHhgqUHiVjD07S20/adi76
         A5KA==
X-Gm-Message-State: AOAM532OQz0J/iZyvEZkgclQm6SqgA40IR9gTNcztDsJYj2vkz70BdqO
        jMsFRvaPNFP5jEsjKzhclj8=
X-Google-Smtp-Source: ABdhPJxb8SajYw85oD0ETALA1g8P+Gea5rsMXujMPh4tPVcPh6hXLpGiqDCBPV9pJr2CvaTX46hY5A==
X-Received: by 2002:a63:e114:: with SMTP id z20mr2415276pgh.300.1593253297259;
        Sat, 27 Jun 2020 03:21:37 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id l126sm1064898pfd.202.2020.06.27.03.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 03:21:36 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 27 Jun 2020 18:21:29 +0800
To:     Joe Perches <joe@perches.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
Message-ID: <20200627102129.iizp5rnj27viyfti@Rk>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
 <20200625215755.70329-3-coiby.xu@gmail.com>
 <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
 <20200626235725.2rcpisito2253jhm@Rk>
 <324448187976fc690ea63f1c18e063fb0b09f740.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <324448187976fc690ea63f1c18e063fb0b09f740.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 05:06:33PM -0700, Joe Perches wrote:
>On Sat, 2020-06-27 at 07:57 +0800, Coiby Xu wrote:
>> On Thu, Jun 25, 2020 at 03:13:14PM -0700, Joe Perches wrote:
>> > On Fri, 2020-06-26 at 05:57 +0800, Coiby Xu wrote:
>> > > Remove unnecessary elses after return or break.
>> >
>> > unrelated trivia:
>[]
>> > looks like all of these could use netdev_err
>[]
>> should we also replace all pr_errs with netdev_err in
>> ql_dump_* functions?
>
>Ideally, anywhere a struct netdevice * is available, it should
>be used to output netdev_<level> in preference to pr_<level>.

Thank you for the explaining!

--
Best regards,
Coiby
