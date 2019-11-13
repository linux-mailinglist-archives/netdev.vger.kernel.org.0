Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB864FB5FF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfKMRKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 12:10:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33706 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfKMRKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 12:10:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id h27so1779173pgn.0
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 09:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y2EFycocOTFDQi5LnP6cTlfzgOXuhPysyRl3IXcjR+w=;
        b=Uq5hG/ATUyd8FTqcOWnWrUEJ7ak0tiKIWiY0eqGcusHG56t/DQJUWZNEtAFOzSwkPd
         Z6v3R+xQpvqOXMc9OikHlWSka4bThIFRuDjHXzFH9X/r/P4UT+qpybAVw6/B+tKcT6m/
         5y82M9KERoZ3urT1t+ybFvGhRoAihgXB34N//Oyi0nBHl0bO/+qQzF9QKoX9aeqVWm0E
         3H6LTdmfRqqAXKHFwHmgiKXJMbrEhNCmP8L4NtPhgnrOIFS9Cn1x4sD8PEZjULkymHq2
         cJqyT1Tq3Ty4XclBarG51ni8NFnsMA8X50KrWCteJARM9+ZWuwGmPMkqUquAVwYpg6OR
         hk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y2EFycocOTFDQi5LnP6cTlfzgOXuhPysyRl3IXcjR+w=;
        b=MuBRI9qhGg6UNfquy7NnYLKTYK9f01txxkKtoGcQMS4TA+9WQ4ReGLx7Fi754elRuC
         lHX54VUCIHkErAxeRWBi2YvSJmLvvrAO8RmqmR2hksf+7eIKYe5Y4HEy+qJwi8xB2TLg
         8AWkQ4bhyZQfCIG/haX8+SClC2jCm0F1yAG+6FlH1qk4EawBBSpype1ME0iidb1VL0LF
         betK9wcl1aOS6qdVL70WmTfk62qJaepO6MBogsgv1oMpp6n0YZHa9lRRgmHPBJ1bFaEH
         OQeZO+cmv3fzSvinQBPdWcER2+w+sKmBbyrnJ81U8Le2Qw2duKxr03wshn4HVpE7njbD
         cqzg==
X-Gm-Message-State: APjAAAVjfmiA+PoQuYM1vHXm0oUualK26z3K+b4Yf5BaNVkzv+mZoHPf
        +dlMSqQj5SGBi1CDiiY/Ro8=
X-Google-Smtp-Source: APXvYqzU8Q4LrKMSUKbOLlL+2TDmP67CvgBmNGy76t1FwqQZC8uhYB381rk6dxgE6nld1D1zPemYHg==
X-Received: by 2002:a63:7cf:: with SMTP id 198mr4908885pgh.372.1573665014336;
        Wed, 13 Nov 2019 09:10:14 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u207sm4396691pfc.127.2019.11.13.09.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 09:10:13 -0800 (PST)
Date:   Wed, 13 Nov 2019 09:10:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next v3 0/7] new PTP ioctl fixes
Message-ID: <20191113171011.GA16997@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20191113015809.GA8608@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113015809.GA8608@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 05:58:09PM -0800, Richard Cochran wrote:
> There is still time before v5.4 gets released.  Would you care to
> re-submit the missing six patches?

Or, if you don't mind, I can submit these for you, along with the
STRICT flag checking for v2 ioctls that we discussed.

Thanks,
Richard
