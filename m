Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27FC6267AE
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 08:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiKLHij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 02:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiKLHii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 02:38:38 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D391B783
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 23:38:37 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 78so6061403pgb.13
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 23:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fuJxEvQ8hWJBVA+YQn5WV9w4flp3A4j0tI4rSSd1Ck=;
        b=cw45AqCUuB8ApCLRgOV9wJV3OFN7/CPZJFudJkCrGgedNjLk+8Lyo+coO3zx4ZQwes
         vcGEFAFwgO85msXq/YAj5lY9qClAx2V5/RaO8Nkknew5cilfjfXVRMN7XJTM4ooc2WMJ
         bu+z8X7N8nrzUvQmt3FlD9JXtBVkqEgV632Hcz0hQLPVQxyJ6BOX6VAqeIlPrBPeDaP1
         PAPSNrgWnu3vyRuAefAJZ/r6OurbBPD+B3CUe0B1mdzSxACxfHd+IOuUF6Qxw0L2diZJ
         9Bshn6UxqK4+tslajDpIX/lVXIHLzzwjsgPUtAiqCcbi8IU6KAKXrWa/ZQKEk+CVPGjl
         jl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fuJxEvQ8hWJBVA+YQn5WV9w4flp3A4j0tI4rSSd1Ck=;
        b=3wZhJ/Xj8VenohkhZjZW7IGyXUOZKI3ZCTYmfJPFNqeRYe/d9Z2HQsOMSJcJ0mSkgY
         CwGCFIkeroai/u9gNRDdIvWIgwz6pdvqLtKuiHrO7rUXU9vitC2vJEe2SRLGZuzZBvOv
         QShn/X1DrKCyESzhfAu6vasrKjVopFLko53VOoj3K4iB27G7gZGV8Y0eMIsqqId/I7QY
         s/0BnH4x9NMc4QjoFOoZ0Bgq/voekOuVvXy2LNP9RCy2dASiGKMOZKQpN4UEx8URZVx/
         b+oH9zDD5iYvpw8BLqHmYP1oMyjlKWlibLttqI/2bHn71AxqK/UWtbE0VQFGHveFYpp0
         r34Q==
X-Gm-Message-State: ANoB5pl6/9O8Ge9cBlu4pRYLNV4USTrCzqbxxsQ2hiYU80D+fqlTOnMo
        eD06yNAxpwwdqpaHcKamon67Dz4ySJ37kwPk0gI=
X-Google-Smtp-Source: AA0mqf78t4yQQjMbssSM6IOJk4V0WDlQmxE+nmQKIxcR+3IejGeBOm8fGvDzOTBoTgtU9K/j0+dFsvH0h85Oh5gpHVM=
X-Received: by 2002:a63:2212:0:b0:46b:1091:16e0 with SMTP id
 i18-20020a632212000000b0046b109116e0mr4449173pgi.587.1668238564192; Fri, 11
 Nov 2022 23:36:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:1693:b0:352:589c:a6d0 with HTTP; Fri, 11 Nov 2022
 23:36:03 -0800 (PST)
Reply-To: seyba_daniel@yahoo.com
From:   Seyba Daniel <soremoussa994@gmail.com>
Date:   Sat, 12 Nov 2022 08:36:03 +0100
Message-ID: <CANdXxzS410KoynUKfjrVGcefJUCSuvGwY+-k7_2r=7diD1Jh9A@mail.gmail.com>
Subject: hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it, which you will
be communicated in details upon response.

My dearest regards

Seyba Daniel
