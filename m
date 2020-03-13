Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1515184CDC
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCMQtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:49:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43830 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgCMQtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:49:10 -0400
Received: by mail-qk1-f195.google.com with SMTP id x1so8758076qkx.10
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FmRBGgbeyZQ4puB57NT8Sof7/pO+vP+mNUY77fyl/y8=;
        b=IMAfVUco2dykyQYb+F0HKZrTJN0cspRd/0PQlHPV3DNr2kuLzwua7K7Wt9R5Dz7mcI
         Qye+oIb6V2FqqZCZmAgmQxV/3PwTkMYeb93fFDfAeqVhn+QLhhpcR8GoZuFApWYbA6x3
         dXzfccxOa4WqQP8r3WonqAeJa8txecZXxarYwJRPiM0KC/cec4ev2m13o8U7Lin4ObkW
         b4XftY0qJwQrsXl8F/1bKIQdLrSZGnBk72BMPwRcBXVaHWxWR06N6VPzABYxcoInlAZo
         1KMhgQL8DfueY6gV44K5RwrHvZui8qD4/2xmc2UEbwyRBacMfykCpoGOmwHhCwnK19NG
         6idQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FmRBGgbeyZQ4puB57NT8Sof7/pO+vP+mNUY77fyl/y8=;
        b=jJqmYqSlWTFUUD85pQqdYyeWRtedS9l6RxT0+PV3EFeV6LpO/rdsIFvtX9N6+Y8gbc
         1gkMd5CJo3m7c44JMsJJ3ngGBlSapXECEpdaIgl4hNXRaWVwED/yXgEMOXQHaMueFp0s
         MWjQXqFpnLKHEzJdsW78qNKib3WNbKASH2hNQyoSiYfeUVg5sUlI7tqMbv5dFYYSTY8f
         CJ9MlEyZx+P1ueRhE4azMt7B/thRQFWLgsN4JERnn3RFMQO+cezH9pKa4uA50qisWHMv
         /A1uC8luB8Gmzwpah/3AHyGWBMCkd2/saUbaefCXJni+B/xJvF2BBlsm9RgcPXYxZDWi
         ujFQ==
X-Gm-Message-State: ANhLgQ3MCyGgvI4lgfWepcB0kZWuCOhI6rbWfPsAOxKunVHkMftHjo/+
        GGrWNUvEhBQG2aaJcofb/KdSmEU6uss=
X-Google-Smtp-Source: ADFU+vvN07S5pdQ4bZzRfVteSIayDd4ZOFYVbgUPwPa1xIgZFTTeOF3bmQChTchvqBtR+r5SK4MTKA==
X-Received: by 2002:a37:8e44:: with SMTP id q65mr14132845qkd.70.1584118149079;
        Fri, 13 Mar 2020 09:49:09 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.211])
        by smtp.gmail.com with ESMTPSA id l4sm7227174qkc.26.2020.03.13.09.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 09:49:08 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 99045C58FF; Fri, 13 Mar 2020 13:49:05 -0300 (-03)
Date:   Fri, 13 Mar 2020 13:49:05 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     paulb@mellanox.com, saeedm@mellanox.com, ozsh@mellanox.com,
        vladbu@mellanox.com, netdev@vger.kernel.org, jiri@mellanox.com,
        roid@mellanox.com
Subject: Re: [PATCH net-next ct-offload v4 00/15] Introduce connection
 tracking offload
Message-ID: <20200313164905.GM2546@localhost.localdomain>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
 <20200312.150600.667394309882963148.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312.150600.667394309882963148.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 03:06:00PM -0700, David Miller wrote:
> From: Paul Blakey <paulb@mellanox.com>
> Date: Thu, 12 Mar 2020 12:23:02 +0200
> 
>  ...
> > Applying this patchset
> > --------------------------
> > 
> > On top of current net-next ("r8169: simplify getting stats by using netdev_stats_to_stats64"),
> > pull Saeed's ct-offload branch, from git git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
> > and fix the following non trivial conflict in fs_core.c as follows:
> > #define OFFLOADS_MAX_FT 2
> > #define OFFLOADS_NUM_PRIOS 2
> > #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)
> 
> Done.
> 
> > Then apply this patchset.
> > 
> > Changelog:
> >   v2->v3:
> >     Added the first two patches needed after rebasing on net-next:
> >      "net/mlx5: E-Switch, Enable reg c1 loopback when possible"
> >      "net/mlx5e: en_rep: Create uplink rep root table after eswitch offloads table"
> 
> Applied and queued up for -stable.

Thanks but, -stable?
