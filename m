Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36051986A2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfHUVbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:31:13 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:43983 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfHUVbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:31:12 -0400
Received: by mail-qt1-f178.google.com with SMTP id b11so4911980qtp.10
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=w5C4YXASS0++1bj4iMPKhL92RQvUv3bossS0lzJwxAg=;
        b=sYAhLcLz6wqQ/N6Mw+JhyCFNyXawCfpM6U8NWJ8eAzCff3YrXj74c6nwPbIGyLtR0d
         TTSlKIRp54q7rmVxEfQ/5prDXq5Kh/XBQ/Y4a7Wl73OQGkBeIZ1qemPI+b0KKRPQ3iMj
         wvyzeXdygYbdrjyqI3zPQwQQNmoXUkybH+7GgF9pe7FpiVksNczIQhN63h52aGYd08LD
         nlp7c2LrRYhxjdfi+KNGVWM5Mo0JWplWjPFl/hgfmSB+afg6Ac/qz4gRFQ7PBJV0mtpV
         243S5Uo23Cd3rZKxAEgjFropeB20e1KiFFScMF+sJLocj5JpxPWUBqf72JyNeoWbs8lP
         AjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w5C4YXASS0++1bj4iMPKhL92RQvUv3bossS0lzJwxAg=;
        b=sUcQwf2bDAZjUgZTc5a8OD7MehS+o/nPwSMRoywXsZH5yKDc+mNfj1MEtPE0vS2itC
         Ypy6dyngD8MNQfBcK38vpKfAPM5kTZVvcryS+7pslXavf/iNbsi+7/OlwRkN+I/Tph8w
         FFwu0l2+pu147oyJwBtJkadVf+fX59GsxP7wePStVhCiMU+hvnjMVebo/T4dPu2ouHBt
         9liM0xWTzp3uMoQnLp66Mazz7TtatRkxR0o0j7goG+mh3UkTpOqeFEagRvrxdFPW4dyW
         ax9lFGenns2bzP+Q4IkblI7s+OJ/z3/0Vkscp4C5+HNWe+YSSlESItYARnJw6EZOr2WH
         sMNw==
X-Gm-Message-State: APjAAAXJT5gqKHojb+kPe5AwdPlFCWJp3iRaBX66KodVJr0UjFwUJSii
        F9HpM40Sv/RYkcl5FjEXq6iAvA==
X-Google-Smtp-Source: APXvYqx/hb2nU2zEO9toOaxbTmHLaXaINWa8MqD2cV2vCCs3PUTuOfLuUzkXfbCK8lMZyPLOpWuxQA==
X-Received: by 2002:aed:359d:: with SMTP id c29mr34728536qte.4.1566423071824;
        Wed, 21 Aug 2019 14:31:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r40sm12460297qtk.2.2019.08.21.14.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 14:31:11 -0700 (PDT)
Date:   Wed, 21 Aug 2019 14:31:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 00/15][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-08-21
Message-ID: <20190821143106.0a2ac71d@cakuba.netronome.com>
In-Reply-To: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
References: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 13:16:08 -0700, Jeff Kirsher wrote:
> This series contains updates to i40e driver only.

Patch 12 should really be squashed into 13, 7 and 9 could also be
combined. But not a big deal, I guess.
