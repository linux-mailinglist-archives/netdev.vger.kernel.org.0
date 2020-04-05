Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24119EB95
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDENtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:49:50 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:40680 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgDENtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:49:50 -0400
Received: by mail-wr1-f45.google.com with SMTP id s8so12046654wrt.7
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=xtfoRjhWf642zI1+H6uMDpR0mtXxyw3DLNJ52bvvCCw=;
        b=M4Y8RupOqBloQIwEidrHc4RZnroymrP4eo1q9068SyD8bUsxz2/7cHgqX+j5F5RpwN
         KFzt/BMwb0ljsKI5jf9CquKFovTgWnR0y2KmoS8IkcR/xG8zrjD9TqiC7AcysWf00Gr2
         xwxJkKh3Na9aLgDSdxEGRMBalOj24cPNqluyMVs/tcGJhCNraBfaa9Fy0/B8C1twGSt3
         NYSHcfj0ZQcSOhP7q9/AcheFv6783lo8e/1LX9l+bptQEf0mV0PTnGv5v/IE2oLx3Pfn
         sjXCq+Lib2ceYb+2Uw3FJFLFgftokr/qZfpcl1cL7H9fa4tkPwgBdp1O9js5EPWTK29P
         SSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=xtfoRjhWf642zI1+H6uMDpR0mtXxyw3DLNJ52bvvCCw=;
        b=oa9W0XhS0qZs0OrCIDCv2rWdsBC224JhsfOdJpX0ORUC1Z9QjJI0oqx1F6L3WzgkIc
         lUT1bgroUnAUwp1exDsaAKXdX0tkxdqh3/BhCeKUKtdp6VrVZ5cLSsmoJDgwEpUc+ugU
         Lixatan6Oj28cgqAp0vnCoBRJjg5lFYiH936NNvT9VB5oRaNrjKGx0ERWrcA5l+i4KbZ
         0zNWiWlIYwyVtYBzGOqV1xJBT1Lf2uxABJ+hpn38XTjDedDKn77oc11+GNY1JssJsqjD
         JiHL/Eutm9E+4C0Libn8DN2p0IywHVm4UnviiIkeMGvd0/+1abXrzKa6gJ+DdNob1xpQ
         /cow==
X-Gm-Message-State: AGi0PuYIKdTdjvWnejm2L6eUUis+A33YIz2KA+ieFvi33JG7p1aXo31B
        R5Ttf0MF45saDuK5NFWq9CUd0Hxs
X-Google-Smtp-Source: APiQypJZvKKerA6c5d7Zs3FDljp5rryiwPhtVF0OS//p7SWk8nSRRuzvtFYM3uLCIpX989jKh1F05A==
X-Received: by 2002:adf:cd8d:: with SMTP id q13mr1710113wrj.400.1586094587747;
        Sun, 05 Apr 2020 06:49:47 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id n1sm9014376wrw.52.2020.04.05.06.49.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:49:46 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Subject: Improve documentation of bridge 
Date:   Sun,  5 Apr 2020 15:48:52 +0200
Message-Id: <20200405134859.57232-1-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please found a serie improving documentation of bridge device.

Please review and apply

I could not understand some options in this page:
- vlan_tunnel on  ? 

According to https://vincent.bernat.ch/en/blog/2017-linux-bridge-isolation
I need  echo 1 > /sys/class/net/br0/bridge/vlan_filtering to enable vlan filtering

Do we need the echo 1 ? Or could be implemented by ip bridge (better for user experience) ?

Bastien 


