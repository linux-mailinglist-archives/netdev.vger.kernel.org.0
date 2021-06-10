Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D9C3A2535
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJHVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhFJHVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:21:50 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FB0C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 00:19:54 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h15so9503867ybm.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 00:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=XXOc3lnPOnrLHfUpjTBiHdlnPYpmdbZCpUcpd3AYxmA=;
        b=uK+242ZDF+sbZl7cP5jH9yWQWXreTVnFmV7hVkJ41pZnGAVPIgIi9551VLMs60VNPu
         AseamckzE/9NQEhzuAJFEnjhApNv3m3826vJknMcBfb4UCrjgxeQiRplKw6I/K6ZYVxv
         A5TWi0aHt9t9Mmy5nJRwYCI/4FVzCsRNaHd9MlTr+oKeQ3/JRCeCclWlOijFB7qjMjKF
         jA2igzC3ONi4j0bmhnfzq/wN1RGJ/mb+3RXFMp63uNp1rhhOAgS/EAzffL4rRTbMiOEk
         gTsoEqyZjAp5Zjo3khanEZu09H0M+pLWMlitwk0pK+iun4ueAQlASEnIghxqDLcWfd55
         +ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=XXOc3lnPOnrLHfUpjTBiHdlnPYpmdbZCpUcpd3AYxmA=;
        b=nsjLMlR2sYM7XaJJEO8kEMprPgygFey1T7ctvyZdRnITfT6nSikIiKbRkXoWV0jSyV
         IZ+GQwLsi7RIRRLaWNKX1BwUyO5oOE0RlD09eEGhoRufolxcVdcdvQ5ZQupwKdgHyX4p
         KjtenfZo3mLDfvt5YyLnHq/sgcBkp3G95gkar6TgpC7pKViPvTfqIAM/6Slq9wAb5Oec
         NbrfRp+g3JtG1VWj7N5DYHMuZOTF3bjAhKbtAp9P0h5ZtXhbD9SLs1R8WwDpAdvdTa+S
         ougYN9bZhIpgtaEk1rDlm76nwWw4668yFbM1iCReGepRcuLmryMdAw08hnbcQk9oBAKZ
         L97g==
X-Gm-Message-State: AOAM532ocvFR8/5liES4u/u2E48aB6VgvpX6kuwf0asIUv2xVUSYs/LX
        pDDQXrdOO6wgvojhR/C0/jcwsl2SX/T9NOcW/ps=
X-Google-Smtp-Source: ABdhPJxq1VHUTuwQHzpagiIMNrrWHe9d4GTUxy8q9eqqfMV7FCNil26EWTfSx88gqIuehdAzUTrWH6HNcgcilBmqZK8=
X-Received: by 2002:a25:420c:: with SMTP id p12mr5787312yba.25.1623309593785;
 Thu, 10 Jun 2021 00:19:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:4f95:0:0:0:0 with HTTP; Thu, 10 Jun 2021 00:19:53
 -0700 (PDT)
Reply-To: c1nicele@gmail.com
From:   Stefano Pessina <taxforcerevenue@gmail.com>
Date:   Thu, 10 Jun 2021 10:19:53 +0300
Message-ID: <CAOU6uFHoSv+n3GfBmbtEoxYf46cgzAerrALsGBzw+=9xArsmXg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

I'm Stefano Pessina, an Italian business tycoon, investor, and
philanthropist. the vice chairman, chief executive officer (CEO), and
the single largest shareholder of Walgreens Boots Alliance. I gave
away 25 percent of my personal wealth to charity. And I also pledged
to give away the rest of 25%  this year 2021 to Individuals  because
of the covid-19 heart break. I have decided to donate $2,000,000.00
USD (Two Million dollars) to you. If you are interested in my
donation, do contact me for more info. via my email at:
c1nicele@gmail.com


You can see here: https://en.wikipedia.org/wiki/Stefano_Pessina

All replies should be forwarded to :  c1nicele@gmail.com

Warm Regard
CEO Walgreens Boots Alliance
Stefano Pessina
