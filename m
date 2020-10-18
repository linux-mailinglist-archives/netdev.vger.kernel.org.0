Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37BE291799
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgJRNYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 09:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgJRNYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 09:24:46 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B387BC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 06:24:46 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id u127so175982oib.6
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 06:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=M0k/RuIbchMfcBWZU6RvLNqKhAw2cFRPrGPnDfNNVzU=;
        b=BUESe0O7fLyJgdlIMvq+dKrnig1d8+vbdJDmNLJmAo2tOH0/rxgJIbxHS4ix8dW6n2
         nd2G2ICrsXj3asT3L6XGZ663DvpAKaocGtw9r4Fgdce+BxKl4+RMtH80vZXH6HYkR6n3
         GFGe+aWQ4ti/f501tRf3EyxpIGEde4zAKmBQL1XpG2oRxwojf654U0xjiXgUS9yfv4It
         k95sSR1uzVDObZj2nGxoO/XutSTNgpPevr0zxPQnjB1yiYK/We9dxt9qOjDtZqH1J56x
         /JbzvATHCFcSzzX7xiCQtOgwya8FnatmTbtpJTNc/BPCtvPoSAqJmjxGk2SQ565YfMkx
         LinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=M0k/RuIbchMfcBWZU6RvLNqKhAw2cFRPrGPnDfNNVzU=;
        b=Mxi5d5ZrTaJAMBZ6cUAa4x3lMR3iGUmIf1vnTEDwbgG/oLWUh+PMQCjiqQrVZTRF1C
         /JbMPDINu5TRWd5sFFiWQARxnDwhYMXa9B6C+MDf9kX2h3L6BORnEiWqK7fFmvYQ7/xZ
         GoQoHqQXALpyQcIGmFl1c4WbKzGN/0bwNngVajKqjBf3qg2gmigtcIQGSmjeAsn61peq
         6/0fcsSXWwubGdZ35nYQYHKqt2OEcwQUUcsJtyEQmhnIxkxM8reuM8JY6XSvLbYY11dB
         2Tt214/yQprDbAGA6K+KfXM6cONA2FwvIMa250RmKzLM86djXDeKJj9MmJrLIKheiquO
         IUJA==
X-Gm-Message-State: AOAM530AFeKMJhcwDtMK6BH7CflvGgcIsEKgKDGh/xz9+EWCWeB4Xqy/
        wPHou7+rbTrB+MrwkXFtjF6ve4scskA/
X-Google-Smtp-Source: ABdhPJzCmuqXYZRiMZjSkxX+Uqt3YLHgRZ0Fpu+Dd+0msom4G5UUNrQLCjndNABfPv5tjJdFv0/6Aw==
X-Received: by 2002:aca:cc0e:: with SMTP id c14mr8802818oig.131.1603027485232;
        Sun, 18 Oct 2020 06:24:45 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id w30sm2754025oow.15.2020.10.18.06.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 06:24:44 -0700 (PDT)
Date:   Sun, 18 Oct 2020 09:24:36 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org, sashal@kernel.org,
        mmanning@vyatta.att-mail.com, dsahern@gmail.com
Subject: Why revert commit 2271c95 ("vrf: mark skb for multicast or
 link-local as enslaved to VRF")?
Message-ID: <20201018132436.GA11729@ICIPI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

We noticed that the commit was reverted after upgrading to v4.14.200.
Any reason why it is reverted? We rely on it.

Thanks,

Stephen.
