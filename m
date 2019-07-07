Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BB6175A
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfGGTry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:47:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53719 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbfGGTrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:47:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so13693848wmj.3
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 12:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J8acB5kVvmCD07ngZ88bXchqjSiy3kNncDOBOzae0Bc=;
        b=Df4ccF2KVxWYV9ewpNLWfP4+I25X64YElxKCY3quI9h9c41l27Y8aidGY0PvHweBhz
         m/qB244rtizqUsa8pzwbgOGcWrHEiDA9kyIj/GZv/+1EMpd2dc9OMBzj1KnVQVSWORZD
         7FRFyL/3I7uPwjF6vEP4wPkthAlseFG/l1CtzfNmzgb4r/Rt7jZZ7tgaqch8WgRCwgsX
         +G6jaNfZCqIDG/37v035tY6VkF8ZEHB0cGHOpUvNQEChdl0Gq+DKPZmclaDScADyZo97
         T3uayKPDr7llLTzhz9lXeyeoMwD+qrJehhWqBQxoYoAQfdMjV5VGQDJU9FnchQji5aat
         D3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J8acB5kVvmCD07ngZ88bXchqjSiy3kNncDOBOzae0Bc=;
        b=nzMMKBXwU5bRo3PrqCkS4dovhyx4wlzBksSu0CfsJxhC+hva+my2ta6c9XpKIS/AXE
         u2W8DPYoiZfvzQM6i8mRS9TF6D4JL8M5p7/s0fZoUWrhWflAyeKrix/WJqfh05u0w073
         FybpiWIjQROCToNTaqqQFfVU4EpjVkan3CETCE/i/p+CWwEU3uWNomBb6LZq189Zu3XP
         /KKmEtfXAEDFRF83kmVPzHc+JzTz8zF7zun9D8rW+40T8A/CncyUIDNyFEFzzfLmE/EM
         oGK2F0O7n3X70I41ivcawIVtqwlyMV+tlsgwWPmka/18sbHX7iA7Bjl2Vaoi2th7694K
         LWyA==
X-Gm-Message-State: APjAAAXDDFCMt0Irq42Nc3nfkgVdnAL6JomNHU8fdHsDQqW86CY2oL3G
        tz7dHRv236Rpy0Y1Wd3enodwhQ==
X-Google-Smtp-Source: APXvYqxI8MuxAIiqJ5+pgmE/U1q+quR+oheoU007lGatSAgUHx95je2YP6lZBjgfqLdH8LopbPAYsA==
X-Received: by 2002:a1c:c2d5:: with SMTP id s204mr13342470wmf.174.1562528871639;
        Sun, 07 Jul 2019 12:47:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u186sm13180749wmu.26.2019.07.07.12.47.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 12:47:51 -0700 (PDT)
Date:   Sun, 7 Jul 2019 21:47:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v4 1/4] devlink: Refactor physical port
 attributes
Message-ID: <20190707194750.GA2306@nanopsycho.orion>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706182350.11929-1-parav@mellanox.com>
 <20190706182350.11929-2-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706182350.11929-2-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 06, 2019 at 08:23:47PM CEST, parav@mellanox.com wrote:
>To support additional devlink port flavours and to support few common
>and few different port attributes, make following changes.
>
>1. Move physical port attributes to a different structure
>2. Return such attritubes in netlink response only for physical ports
>(PHYSICAL, CPU and DSA)

2 changes, 2 patches please.

