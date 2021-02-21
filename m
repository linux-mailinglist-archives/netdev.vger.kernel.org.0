Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A49320DF8
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBUVfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhBUVes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:34:48 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70580C061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:07 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id t11so26067544ejx.6
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AKsQ4gtGJ8jTbtTvuoZDPTvaoIlVet9b+lBdHfkMdhI=;
        b=ecStwvMNprNlu0rWimauxsja9gJST4ZAPyO6UyhDlFWCWukYypBQ8f740tJs4NKA3V
         1egcm9RuJrR3O0L+RKRYDgBsmSeN/7/RPSxLA9W5OmLkt6BStDhA61obdEsWE7ZGEZ/Z
         cNOPJ8ApomMceMVbPPaAu2c6G+f+/sBRcpktgptzH36PwGhr4DPmvcLmoIMFn+qvI4WZ
         2DWX4nVK7TiH5MfF1NTXe50ugW7tIhcxG9pxiWu70GwU5Pjo90fp4gsTmVTd+KXOQhHE
         oZ89sjWoJyya905y1YHl9k6OUuYLRSyWlLvnp8ABFs3c12zELe7cDPZg6rA7bFYtjkt6
         BkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AKsQ4gtGJ8jTbtTvuoZDPTvaoIlVet9b+lBdHfkMdhI=;
        b=IbFK9pLxzcZQbZnu5u6wPb4RjlBM2Q3hKOVUUq85VWV5LhKAHFvNACAmQeXsdRbJTs
         Df0jnTYXC8lkWhgSG2RlxT+bFDNN00q8ioMRkpyfWRdaeJlrHHfoeN298Qe95axiLiKg
         HjarBayoiw2Am8GfgorZ89y3yP4YZRWXmOAv4pW5Mc1z3MDvy3ik3u6LES+IXNShz8Ra
         JcW+TSYP31OcVlNBOvgjgjf8ypNswjB93VCP7dgjVk+33eNmAShFyjW3MCYa4p+KHUi9
         mWMsPjgYdNSLRpFBCrfXG3iecBwynlLKz+P1phumbLQOQPsyWA6hAUDnSJViwLvjab8k
         v4Lg==
X-Gm-Message-State: AOAM533kRTSzvh0r7bqG66MBdzMfgn+Z4ykr7BwZ5Izp/dRcIvwiiZup
        V/EJfBWN6raGs9BMzVz+VRP6UYahM5Q=
X-Google-Smtp-Source: ABdhPJzuhksja6MGTMyGt1EA9f85SftL+1SQ2i0Wpq0/0XzpLuMi1V9szR0Pn0QgefXrBy8ACZfK4Q==
X-Received: by 2002:a17:906:43d7:: with SMTP id j23mr17973677ejn.519.1613943245517;
        Sun, 21 Feb 2021 13:34:05 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:05 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 00/12] Documentation updates for switchdev and DSA
Date:   Sun, 21 Feb 2021 23:33:43 +0200
Message-Id: <20210221213355.1241450-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Many changes were made to the code but of course the documentation was
not kept up to date. This is an attempt to update some of the verbiage.
Suggestions for improvement would be very much appreciated.

Florian Fainelli (1):
  Documentation: networking: switchdev: clarify device driver behavior

Vladimir Oltean (11):
  Documentation: networking: update the graphical representation
  Documentation: networking: dsa: rewrite chapter about tagging protocol
  Documentation: networking: dsa: remove static port count from
    limitations
  Documentation: networking: dsa: remove references to switchdev
    prepare/commit
  Documentation: networking: dsa: remove TODO about porting more vendor
    drivers
  Documentation: networking: dsa: document the port_bridge_flags method
  Documentation: networking: dsa: mention integration with devlink
  Documentation: networking: dsa: add paragraph for the LAG offload
  Documentation: networking: dsa: add paragraph for the MRP offload
  Documentation: networking: dsa: add paragraph for the HSR/PRP offload
  Documentation: networking: switchdev: fix command for static FDB
    entries

 Documentation/networking/dsa/dsa.rst   | 344 ++++++++++++++++++++-----
 Documentation/networking/switchdev.rst | 167 +++++++++++-
 2 files changed, 441 insertions(+), 70 deletions(-)

-- 
2.25.1

