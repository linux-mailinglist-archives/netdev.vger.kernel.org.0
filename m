Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF541BE0BD
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgD2OWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726815AbgD2OWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:22:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEECC03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:22:35 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so2248218wmg.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=neVbWwDmdiMbzy/Asxd3U/Smb8d6Dvggkg471twxJ/s=;
        b=tvsAbEbK4FwAL5TSL+qCYUqp0MDE/gO0bhsUhB8DbxsabQ0airEe1+0FFMK4vPiIxy
         Euvi2ElaSGGPZxn2S+sBHbEXgedXEIuSrHtkDGCfwquJyh4er76GcTDabhRPWyLZDaG+
         +cm6Ba5blUstjH8RCJJjMeIKeaszfu/MB5MzNcv9S3S44d1i3DTVhZYjFCsYcx5wSkmm
         2EPkuACAgBfVcABCVhH6wtni46tfvZGFSBtAFcTyCJVGOlAcFtf2CoMFJDqEQ0LqIso2
         lnV888cdVao5GKnHDiUBmvbWnFG/prjibZQUXwPpC6GAtTPDp2ZVM1MpsZ5TP+fn6dJf
         gAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=neVbWwDmdiMbzy/Asxd3U/Smb8d6Dvggkg471twxJ/s=;
        b=XjaRqxx/Iy0Mq4UqvLVC0MhMRsl0vFFg9hoAKv9OEKO4tUFzNe0C70Go8klaBzWkll
         MYw59M08cVsINd4Jn92bNyCtlDmjYVLqxz7vO/4C1E+BeCj96Rd1jqZ4hHC1qnNqllAo
         3w8N9Tm+MIBafo9sGXSczc5q9UpoAsTHImE80ZeVfxdq6BvqMep0L6P3amfaxMRxyfyB
         96izrm2HOgaT/9zLr/jZ6PfcHoarAFK01+JGRkppgI0zPwP1qYx2+wBcGEv64e+JjAk/
         m8Oq26qX3xaDuySueIdRpTtqy6e8cJ9uX0RgQpZfUsiRil3ZOtHjvi9GI4eyfgPrCZo6
         phGA==
X-Gm-Message-State: AGi0PubOJAVQ6RPPuSCjpqEpKPJLeXejeqEQA/d7BD/iHOtZoltdlynV
        U4NG8urHhQ93XURl2yNPLxhtdb/ZvAGq62ipKGM=
X-Google-Smtp-Source: APiQypI931yMBXpx4QddwMc2sWiOwaCqFcvoNodgY2K2cFTKQWX107l4PXnHkCoi1QGs2iFJipF+yHWPCoUtvoX8z1g=
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr3494133wmj.73.1588170154477;
 Wed, 29 Apr 2020 07:22:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a1c:49c3:0:0:0:0:0 with HTTP; Wed, 29 Apr 2020 07:22:33
 -0700 (PDT)
Reply-To: barredwinclark4@gmail.com
From:   Edwin Clark <akojovi6@gmail.com>
Date:   Wed, 29 Apr 2020 15:22:33 +0100
Message-ID: <CAFQMMJxYRRR0kpusG_tJsvuLnYspTYK60V7pdXoAbN_v4H16BQ@mail.gmail.com>
Subject: Hi.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Hope all is well with you and your family?
