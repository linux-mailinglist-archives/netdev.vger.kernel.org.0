Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28DE95E31A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGCLth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:49:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38432 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfGCLth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 07:49:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so2051980wmj.3
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 04:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S9V/QrIo8BVJ8mssqOv2wdWJBV+O5Z9tAnibsn5EX+8=;
        b=2N3nyyTUQiGkSvwmlzHhVkaqTiYdsVtuPqyujhGIIPucaPCRKaTlT70Smsst9aecWe
         KRlG4k6kmAqoPd4nBszKrVH7Y+npHNUOotxPTtP5x2uNV95LdgRJSVqO5wW32sR/7XbA
         M7bAXyzoH7rlCZbEP96IiPMllJOxY6nebhUEXm/7qtSiXAMsLcZDYs52XE9OCe2DtkhN
         bHCzqHSM4ToKIScgme2VmmV+e6qYihRFeAlzzqLfvnuIYERxQxAJFYS42fSFnwuGJIf3
         TZRF5Tx5hWjm+u+8VlV53dyC3/SxwqxqfB4+OtUH/40x1uTDfM5jadNCDlewvtxJUrqX
         WwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S9V/QrIo8BVJ8mssqOv2wdWJBV+O5Z9tAnibsn5EX+8=;
        b=FPgv74uHTczEXOTaULQFkiz+23VSgNj5f0cI/4YJtLQ2N3HcU2SXfApuIirMgH52Z8
         AUQen9SR76amaFsfwlgDm1dmquRMhEs4xhlHDrTqTCeUdq/3Hn93AowIQhuEAuU98QZt
         S4TiNtUtig2i0mMAzpGn8j1sMRWB2j3YrjDFSEMbGKKfjrBT7Q3F4jV2+t1n0V8pFvNW
         CNI6VXrY1Nz1aZJI3+SaNmAxCaLArShkmePHqRrqx4Fp5n4VtPPwSMx9wjSQ3MpsG8mB
         Z7RZXvzEmk4vqHLXTV9eV6iaQVpY68oAy4s2vHXX/CdbZXUui+IwSisIU5CkcWECCpMf
         yP9A==
X-Gm-Message-State: APjAAAXmoHEP+terRQXVWsjpMGrEH/y7/DyDXjaz2aJ4pzmgyXW/uOBu
        w3y0gTpAHIwaTY9C22e8UlU=
X-Google-Smtp-Source: APXvYqyCDqifBl22qNuQX6LoC3NtGrzt7+4Oi3nSvEuHRuRNA+ALGN/g9Pt1jEb7KAT/6qRGlOR1Cw==
X-Received: by 2002:a1c:d10c:: with SMTP id i12mr7831583wmg.152.1562154574290;
        Wed, 03 Jul 2019 04:49:34 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id v15sm1753328wrt.25.2019.07.03.04.49.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 04:49:34 -0700 (PDT)
Date:   Wed, 3 Jul 2019 13:49:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190703114933.GW2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:50:09PM CEST, mkubecek@suse.cz wrote:
>The ethtool netlink code uses common framework for passing arbitrary
>length bit sets to allow future extensions. A bitset can be a list (only
>one bitmap) or can consist of value and mask pair (used e.g. when client
>want to modify only some bits). A bitset can use one of two formats:
>verbose (bit by bit) or compact.
>
>Verbose format consists of bitset size (number of bits), list flag and
>an array of bit nests, telling which bits are part of the list or which
>bits are in the mask and which of them are to be set. In requests, bits
>can be identified by index (position) or by name. In replies, kernel
>provides both index and name. Verbose format is suitable for "one shot"
>applications like standard ethtool command as it avoids the need to
>either keep bit names (e.g. link modes) in sync with kernel or having to
>add an extra roundtrip for string set request (e.g. for private flags).
>
>Compact format uses one (list) or two (value/mask) arrays of 32-bit
>words to store the bitmap(s). It is more suitable for long running
>applications (ethtool in monitor mode or network management daemons)
>which can retrieve the names once and then pass only compact bitmaps to
>save space.
>
>Userspace requests can use either format and ETHTOOL_RF_COMPACT flag in
>request header tells kernel which format to use in reply. Notifications
>always use compact format.
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>---
> Documentation/networking/ethtool-netlink.txt |  61 ++
> include/uapi/linux/ethtool_netlink.h         |  35 ++
> net/ethtool/Makefile                         |   2 +-
> net/ethtool/bitset.c                         | 606 +++++++++++++++++++
> net/ethtool/bitset.h                         |  40 ++
> net/ethtool/netlink.h                        |   9 +
> 6 files changed, 752 insertions(+), 1 deletion(-)
> create mode 100644 net/ethtool/bitset.c
> create mode 100644 net/ethtool/bitset.h
>
>diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
>index 97c369aa290b..4636682c551f 100644
>--- a/Documentation/networking/ethtool-netlink.txt
>+++ b/Documentation/networking/ethtool-netlink.txt
>@@ -73,6 +73,67 @@ set, the behaviour is the same as (or closer to) the behaviour before it was
> introduced.
> 
> 
>+Bit sets
>+--------
>+
>+For short bitmaps of (reasonably) fixed length, standard NLA_BITFIELD32 type
>+is used. For arbitrary length bitmaps, ethtool netlink uses a nested attribute
>+with contents of one of two forms: compact (two binary bitmaps representing
>+bit values and mask of affected bits) and bit-by-bit (list of bits identified
>+by either index or name).
>+
>+Compact form: nested (bitset) atrribute contents:
>+
>+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
>+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
>+    ETHTOOL_A_BITSET_VALUE	(binary)	bitmap of bit values
>+    ETHTOOL_A_BITSET_MASK	(binary)	bitmap of valid bits
>+
>+Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
>+to a multiple of 32 bits. They consist of 32-bit words in host byte order,

Looks like the blocks are similar to NLA_BITFIELD32. Why don't you user
nested array of NLA_BITFIELD32 instead?


>+words ordered from least significant to most significant (i.e. the same way as
>+bitmaps are passed with ioctl interface).
>+
>+For compact form, ETHTOOL_A_BITSET_SIZE and ETHTOOL_A_BITSET_VALUE are
>+mandatory.  Similar to BITFIELD32, a compact form bit set requests to set bits

Double space^^


>+in the mask to 1 (if the bit is set in value) or 0 (if not) and preserve the
>+rest. If ETHTOOL_A_BITSET_LIST is present, there is no mask and bitset
>+represents a simple list of bits.

Okay, that is a bit confusing. Why not to rename to something like:
ETHTOOL_A_BITSET_NO_MASK (flag)
?


>+
>+Kernel bit set length may differ from userspace length if older application is
>+used on newer kernel or vice versa. If userspace bitmap is longer, an error is
>+issued only if the request actually tries to set values of some bits not
>+recognized by kernel.
>+
>+Bit-by-bit form: nested (bitset) attribute contents:
>+
>+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
>+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
>+    ETHTOOL_A_BITSET_BIT	(nested)	array of bits
>+	ETHTOOL_A_BITSET_BIT+   (nested)	one bit
>+	    ETHTOOL_A_BIT_INDEX	(u32)		bit index (0 for LSB)
>+	    ETHTOOL_A_BIT_NAME	(string)	bit name
>+	    ETHTOOL_A_BIT_VALUE	(flag)		present if bit is set
>+
>+Bit size is optional for bit-by-bit form. ETHTOOL_A_BITSET_BITS nest can only
>+contain ETHTOOL_A_BITS_BIT attributes but there can be an arbitrary number of
>+them.  A bit may be identified by its index or by its name. When used in
>+requests, listed bits are set to 0 or 1 according to ETHTOOL_A_BIT_VALUE, the
>+rest is preserved. A request fails if index exceeds kernel bit length or if
>+name is not recognized.
>+
>+When ETHTOOL_A_BITSET_LIST flag is present, bitset is interpreted as a simple
>+bit list. ETHTOOL_A_BIT_VALUE attributes are not used in such case. Bit list
>+represents a bitmap with listed bits set and the rest zero.
>+
>+In requests, application can use either form. Form used by kernel in reply is
>+determined by a flag in flags field of request header. Semantics of value and
>+mask depends on the attribute. General idea is that flags control request
>+processing, info_mask control which parts of the information are returned in
>+"get" request and index identifies a particular subcommand or an object to
>+which the request applies.

This is quite complex and confusing. Having the same API for 2 APIs is
odd. The API should be crystal clear, easy to use.

Why can't you have 2 commands, one working with bit arrays only, one
working with strings? Something like:
X_GET
   ETHTOOL_A_BITS (nested)
      ETHTOOL_A_BIT_ARRAY (BITFIELD32)
X_NAMES_GET
   ETHTOOL_A_BIT_NAMES (nested)
	ETHTOOL_A_BIT_INDEX
	ETHTOOL_A_BIT_NAME

For set, you can also have multiple cmds:
X_SET  - to set many at once, by bit index
   ETHTOOL_A_BITS (nested)
      ETHTOOL_A_BIT_ARRAY (BITFIELD32)
X_ONE_SET   - to set one, by bit index
   ETHTOOL_A_BIT_INDEX
   ETHTOOL_A_BIT_VALUE
X_ONE_SET   - to set one, by name
   ETHTOOL_A_BIT_NAME
   ETHTOOL_A_BIT_VALUE


[...]
