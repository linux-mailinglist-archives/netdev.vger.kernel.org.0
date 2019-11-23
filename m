Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD32107C41
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 02:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWBIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 20:08:48 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:36432 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWBIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 20:08:48 -0500
Received: by mail-lf1-f42.google.com with SMTP id f16so6887277lfm.3
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 17:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KnqtVtQVM44cZh5T+azTshf3dVbQnTWZePHpkyy5QVs=;
        b=PMtsWt8twjFMPOF0XDe97tds30oM0pSidA7kZzq5MCWPtoenEjddrpqdCth17oW2Dw
         g+lPsk8YOXytVUeectSxgmuYI18+p2J9nM3bZg8XUgJqgws4YpG3gHxWX5Amhb+a2ipP
         +jX4GEgTfTTswcb7WHVesoXA7c2p+dFBdEzoqPhyrfkTwSxXAjrBYD6bh+FDA/XuJkuY
         tf65XnOR46GfAPwbHZXWnL7qKafZCn7if1mL/CI/9L6NhtEQN7fngLb0upxCWa1tegHO
         G8ReMd8rmt/bMVcOINviFTm6QzQ2LG2ddPzw6YFZpAg5fX9d+tzRD7Mnxbf765ezXATN
         JnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KnqtVtQVM44cZh5T+azTshf3dVbQnTWZePHpkyy5QVs=;
        b=PcM57wLaTqUpbhl3EVVSanECRsIlNhT7HsqfOXKAY9nSngdhNpTKUeg3nmQH1pnROl
         Y4ph9FZnyhglOUgocpi41XxEZbA9PSmFildX43lRfd+uC1wF/CN1bR7afGdNnGQhQJbL
         v2NKT9UObONsl0A1s9QiZTed8+QEUY9A4GCmZM5TM3ouZTScJ13YEIvqdSxtr+L7w7yw
         vT6o1kuKHUq7ue3syXbFWNhp4c08gtxXVXtlqEDaingQywjTQ40oXwYbJYVNS5Rwt95V
         SBD9f+O0U24WUhwfKp4RJA1x/W0wWCj3ypfpnfo+ez2T4HYzCWRKA3LUM0oiz/0L/pAE
         hV0Q==
X-Gm-Message-State: APjAAAUFW3S4FpSZoftdW9hPoUWdOaka0fCIOPpqzjPKNFcb7a/pe3Bs
        6AIa+dsoABdISo/lKArXfnReHZceipk=
X-Google-Smtp-Source: APXvYqwI+4UPycFXNMENO5GWnf+wjhO+ReTwWX9806OqTbfJI6EiZwl7ht+aa2oqUH0m9QQN3gAaXQ==
X-Received: by 2002:ac2:4257:: with SMTP id m23mr4491364lfl.88.1574471326127;
        Fri, 22 Nov 2019 17:08:46 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w6sm3624563ljo.50.2019.11.22.17.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 17:08:45 -0800 (PST)
Date:   Fri, 22 Nov 2019 17:08:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-11-22
Message-ID: <20191122170838.39fce2b7@cakuba.netronome.com>
In-Reply-To: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
References: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 14:28:50 -0800, Jeff Kirsher wrote:
> This series contains updates to the ice driver only.

Applied, thank you.

I'll try to queue the stack leak fix for 4.20+. That would had been
easier if the patch was against net, but I guess merge window will 
open soon..
