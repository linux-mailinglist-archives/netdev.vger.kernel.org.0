Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E85FC9B6
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJLRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJLRFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:05:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5903F93792
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 10:05:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n12so27115331wrp.10
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 10:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBXVr+2yQA4Yc+mJwCPapHs1PcqJSd/+SbzdjhsE7eQ=;
        b=ndrszZprH/RZtxsP2qgy9YTsD8p6B80u8tqSdsEIzeztiFhE1q1qJO3OpsZLqbXmmZ
         2Uj7gpVKiMPO6HU2L7j4DrgS2CWU9KcgVCMHeUX8us108c7wcYpBB7gXze5ZWBl953Gv
         AcoJvAca5bTYPCsSi8/hjVnkzpiklMUjrQRAMfjPvkGeIJRtoiT1xVuSGMLuTQ/UnR2J
         bBP6DJHjMm6EAXyM5cqhLnASJJpmsOts3fJmwTT/lTpNlNrNyv4ADfxcXlCrW3hllUZT
         clP5XDj1h8evQ+g+AjOCMwcAo2se/bc8hC43sbjS817zQCpRTj1A8yYGQMPj5kq0iqNg
         X6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBXVr+2yQA4Yc+mJwCPapHs1PcqJSd/+SbzdjhsE7eQ=;
        b=Qgeoa/9zFhFHjxvSt9Zxf/ytmtkW80yMQmboGx3L3DfE+QWRMepLeU9dJkM1mjiJj8
         XNVqN5LF8wlZq4HS4ckjzKGN1/vww6j+p1uGMMId9sDi4LwiRy6+kk8dDUt53KMIG0Cw
         hOT77NNTDDdGvahXusiXiehBIMqoqi+bWUVsmHE7uvyu/DRe/lLBP3iAWGC3P9OSm7k5
         qABazKvuxXzHMcdA+rgG9jHG+AtJkFCxdLE8WLttGA11Vv1hxfkKzjgizEK2mPv1zNyw
         Wny49hY9vu4CIqi120AZBZqRxzR1dDg0CnpCsrq9qtlvfHlj2bQwXcXM+m8kS6mJ43jb
         Y0eg==
X-Gm-Message-State: ACrzQf027Tao5R96lBevHc8NoFlrPnMXk2+dwcHffOq1dOLXEszw5M8c
        cJYKdJ73WRVrc1xuVqAXnMk9v5Jn+6uDD1cdqYw=
X-Google-Smtp-Source: AMsMyM73adwAmQoUiTt/OT1vyabqvhFLJTGSAfvxl6dgWKCGvZ55CzcTgjS2aP7/IVuxwD77WVTYqWfhEnrPmEqrowo=
X-Received: by 2002:adf:a40c:0:b0:22e:47fe:7ea3 with SMTP id
 d12-20020adfa40c000000b0022e47fe7ea3mr18124350wra.248.1665594340051; Wed, 12
 Oct 2022 10:05:40 -0700 (PDT)
MIME-Version: 1.0
Sender: georgeghuba1010@gmail.com
Received: by 2002:a05:600c:4f11:0:0:0:0 with HTTP; Wed, 12 Oct 2022 10:05:39
 -0700 (PDT)
From:   Chevronoil Corporation <corporationchevronoil@gmail.com>
Date:   Wed, 12 Oct 2022 18:05:39 +0100
X-Google-Sender-Auth: SmMuJXaKNZ0iEFVY8hlp-JsoT2I
Message-ID: <CACG8Gj7vYTBUE=CXSKRehVznA6OsoJSmC5G9buJ5-HA0AE0z_w@mail.gmail.com>
Subject: interested
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BEWARE, Real company doesn't ask for money, Chevron Oil and Gas United
States is employing now free flight ticket, if you are interested
reply with your Resume/CV.

Regards,
Mr Jack McDonald.
Chevron Corporation United USA.
