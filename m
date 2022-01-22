Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B761F496E16
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 22:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiAVVMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 16:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiAVVMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 16:12:42 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A2FC06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 13:12:42 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id t1so14619240qkt.11
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 13:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=2sXe8OnEy5tHpjKg60R0Ff0ADmQIY55eD9X8p0CO2Yg=;
        b=Hfv6lgFD5NBakCMymO7QFYNFSyfDPKLaBKyu/APbEgSmIVLIOk427URX5DwwKbU+WW
         4t/3XzZn7SKwoE+K1Cu6sKoxv0WfN9tZBxU6ZeDmiCrgnOi/q8gJLdiGf98a6BCTLzxD
         b+CxVecNJ8vd5SkDQxB8JeIoUzAvPvEgQjX3jtxgTMgphGNzh1BQRX5VMLL3FiuaREU6
         Fa0pLEEVCEXkziW8TIq/AWqW3SjnmEjv9KNAs4+XYuXVY11qOYVH6bd9651ciDHF6bmu
         13QxVbDS/RJfJfVKbUP86GgzY8dh6JyrUdphrh8HAuG/ZnemF1+jPNk3UZWfZZ2eru/p
         wSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=2sXe8OnEy5tHpjKg60R0Ff0ADmQIY55eD9X8p0CO2Yg=;
        b=1e6lxbiIhA11ZlIfOxBdR7668K5Mo68Ro6spjtieSEPtPFxcoqHrmAO3JVdNZYIGZN
         yHIO4SXlZ2ezqC1+x5jIjadUfk8MhyWQhUYXlkHr/d6f3nLy0/xjRMzUZrvlVMV5Zznw
         v8p7PpsM/4I9DxKOKqTr2XnDEQf86SkJCn5LLskfloqvFS4h9Ko2+drBDi1oONDBQG5B
         /ikHAjJySSBdgS3tUgvpx/LSE+D+5SAhYd8JromudJbsqtLQFrg8j8Ct2na23SGx2nKn
         FqTRqwHfYrRmX7SD/iQDKg2YmNOG3VXf699pI6cszqF05FBG8s0Xi6HAuj1whG5FsS7a
         ZpHw==
X-Gm-Message-State: AOAM532WGeJiLxW3lCpj9Vg9T2YANk4fXCPM41iZU9Fn4ayiykzDNrl/
        cTORhYMlveUUoxZckclWfymbJdPXOdnq7kOSmjs=
X-Google-Smtp-Source: ABdhPJw4udSMhx/Zd9+HRmhFe4ewQPvtPbm2b6vKxVG9vwCP2T4s8gmf2vpmqqTtf9p+4a26Ed/Eg+9g4J1zG36dIAc=
X-Received: by 2002:a05:620a:1277:: with SMTP id b23mr1446061qkl.240.1642885961699;
 Sat, 22 Jan 2022 13:12:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:5fcb:0:0:0:0:0 with HTTP; Sat, 22 Jan 2022 13:12:41
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <sylviajones045@gmail.com>
Date:   Sat, 22 Jan 2022 13:12:41 -0800
Message-ID: <CAEsQPx7=Xkg7uQrx8nX3VfO=MG0azfXEN71HnB9Qx3NrM+x7Uw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi,Diid you receive   my  message i send to you ? I'm waiting for your
urgent respond,
