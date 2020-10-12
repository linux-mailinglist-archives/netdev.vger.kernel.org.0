Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF2728BB84
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbgJLPFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388518AbgJLPFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 11:05:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C87C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:05:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b193so13644296pga.6
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AfxnrOWV886CqAK9wDipIrArxg73zx6Y/LaQiWjnxeU=;
        b=v4L2wSAmHYwfhPW9AnvYRMhqSZ/d/4gzviD625vrVN4MEsFgKYsENu44PCuuEwcFJG
         J11UHo/oMWbsqPXmsWkS11yRHonfUbd3CKkDcZPBP7XPebIoJQ9aU8QKb39kIpBd+P1e
         o2zNxGw120JR447oddZamT+76/xt9mloAnYOQFGW7YCecKvsAtr7EonyRRJbLnUfUfSt
         X6ariLjX21l/aHEUD3Aw02V2UBkPK3EDL+P0Kdq3lhCkicayJ4ktIeLJg1WissnddErz
         gFKxrxRBN7dNUEyT39INsCjthYgrRXBdnGNggVwuW9num1iSBttSsW2r5/xcW6VSE/8d
         Cd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AfxnrOWV886CqAK9wDipIrArxg73zx6Y/LaQiWjnxeU=;
        b=q37zGTFq1XqhXPwKkxKbvJJP8ntO9+460QOONNaLfwaPWue+5pWVgJc+2rFWMw7k0+
         nJHa1IoYVyVTh+k4ODX9pH1GuGq0Zu6U1oqAjoD2aVjZNjEQToShJkSSKO7rZi+cc2rS
         gOpn6oOyGC8BoOpMO+/3eJZXzzMVm+6wM32F09u+Y7DoT8GqYhVgOHRb69v/KHxmTAil
         JujyQ5sz0Z7cLzSWHakPZaGOBHJd/s47Y4j2tkZIETPX6ZNwAqYWLDyCTTQri52RbxjD
         C/AGwiEVKpVg0x41QZvDUFyT2bpyZQlP9iXscLwPRIdFCkh0ZDtmYyGKSOfRUAFsxrpT
         fKzw==
X-Gm-Message-State: AOAM533oiOFOV9uPzBJ89jM1N7NbdLTYirL+AXEwsfHWfnIF91a4q7NA
        w7OGAyvxi+Pr7CkoSDliaVXBbGuABprsWA==
X-Google-Smtp-Source: ABdhPJyt1fPthLt/gFA55bipvtqK7I3lKcmmV5TLfbJ+3sBU5skfCoEsogLwy6e4DhYBMgnXLS69DQ==
X-Received: by 2002:a63:4b26:: with SMTP id y38mr10972799pga.342.1602515102520;
        Mon, 12 Oct 2020 08:05:02 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v3sm26323833pjk.23.2020.10.12.08.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 08:05:02 -0700 (PDT)
Date:   Mon, 12 Oct 2020 08:04:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute PATCH] lib/color: introduce freely configurable color
 strings
Message-ID: <20201012080454.6b57ccfe@hermes.local>
In-Reply-To: <20201012145021.10539-1-jengelh@inai.de>
References: <20201012145021.10539-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 16:50:21 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> Implement fine-grained control over color codes for iproute, very
> similar to the GCC_COLORS environment variable.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  lib/color.c   | 127 ++++++++++++++++++++++++--------------------------
>  man/man8/ip.8 |  25 ++++++++--
>  2 files changed, 81 insertions(+), 71 deletions(-)

I like the idea a lot.

But there are some style issues.
Checkpatch sees:

WARNING: Missing a blank line after declarations
#165: FILE: lib/color.c:46:
+	const char *s = getenv("COLORTERM"), *s2 = getenv("COLORFGBG");
+	color_is_enabled = (s != NULL && strtoul(s, NULL, 0) != 0) ||

ERROR: code indent should use tabs where possible
#166: FILE: lib/color.c:47:
+^I                   (s2 != NULL && *s2 != '\0');$

ERROR: do not use assignment in if condition
#188: FILE: lib/color.c:99:
+	if (p && (p = strrchr(p, ';')) != NULL && (p[1] == '7' && p[2] == '\0'))

WARNING: Missing a blank line after declarations
#197: FILE: lib/color.c:108:
+		const char *code = NULL;
+		for (size_t j = 0; j < ARRAY_SIZE(color_codes); ++j) {

WARNING: Missing a blank line after declarations
#207: FILE: lib/color.c:118:
+		const char *next = strchr(p, ':');
+		if (next == NULL)

WARNING: Missing a blank line after declarations
#228: FILE: lib/color.c:144:
+	const struct color_code *k = &color_codes[attr];
+	if (k->code != NULL && *k->code != '\0')


Also, please don't mix declarations in code like:

+		for (size_t j = 0; j < ARRAY_SIZE(color_codes); ++j) {

Iproute2 tries to stick to the kernel coding style, and loop variables
like this are allowed in that standard.
