Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B3A1BB5F8
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 07:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD1FnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 01:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1FnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 01:43:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03882C03C1A9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:43:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f13so23051808wrm.13
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QtOEZF/PECoqKGTJsXSRKqENhPpTlfYqG8MNykZMbRQ=;
        b=XGMFZEjXY1QsQvdd+HuMH2G+JB4Dm5ixviNdZi0+Z2OSp0vIylpSAA1k6MQVBBYjal
         u0BAJfj1bCNSR8C9dETSh56n1B8iwdvD73pPm6pmhlu7LCsFLP3XMoqyz1bwOPT35Sfq
         j2WlmKcoe4E7PemX69GnL/sH7x7ToJP//stMkwwkhwouoSjJ1Vy45ykVOaKCD+m0Mv6g
         FVNAPe211FgHUPwEk08WKJAN7YznmDraDffS8vxI9t3omjgeSioNvgKBgLPdVwz8lXWV
         cE8xxk0Uh4nFE+CjnlSFYXMvGvBAyBSnH7/tRbUXyslqmB2QrWRjDZqqwoTW4CXR4OLI
         147g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QtOEZF/PECoqKGTJsXSRKqENhPpTlfYqG8MNykZMbRQ=;
        b=BrHBMUIJgDgdIioJMvxZRZaDyUt5ujD7gn6cryc4tEwAFulIRqSx5VKW600Kms3v73
         e6qmJZupWVpLwUC3t6SIEzWTsZiSej/scfR67KlyylvyroULjd9TYtJ+4b2rxYHgU7vI
         7U6PP56Ze/kS4v+/RG4PoQ7R6JFh1tt8Xfi0wWBAcCqEVAh0572Dvgca1KomtlvY+hTv
         eRHj/YZu7gc0FwI/woJ7sdu3ro10a0mR9b7eIgU6FtQk5PrGGofNyO6ARCg0Ryqx7jjT
         TyRlM7ZVcoZrD58dh/LgcQTTcIzWEW5a+Clfw4bzEQVvuY4DCRs0gCnXVIYN91lysGD5
         /rfw==
X-Gm-Message-State: AGi0PubColm+8Lx80qpPmpVsb+lzBz84a5wNbS5dG8zr7Vn661bX0RPe
        Fad9m9J0R5us7S0iNu4K1IsiXglWGhs=
X-Google-Smtp-Source: APiQypKjsYWDvD2N4gCt+DJKHLJTj4gMowVYiiMdYwflA3gFjpKu35Xiyv10pjc4Thd4wR2PFEZ3lw==
X-Received: by 2002:adf:db4d:: with SMTP id f13mr29789476wrj.289.1588052602732;
        Mon, 27 Apr 2020 22:43:22 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k184sm1820138wmf.9.2020.04.27.22.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 22:43:22 -0700 (PDT)
Date:   Tue, 28 Apr 2020 07:43:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [iproute2] devlink: add support for DEVLINK_CMD_REGION_NEW
Message-ID: <20200428054321.GZ6581@nanopsycho.orion>
References: <20200428020512.1099264-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428020512.1099264-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 28, 2020 at 04:05:12AM CEST, jacob.e.keller@intel.com wrote:
>Add support to request that a new snapshot be taken immediately for
>a devlink region. To avoid confusion, the desired snapshot id must be
>provided.
>
>Note that if a region does not support snapshots on demand, the kernel
>will reject the request with -EOPNOTSUP.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> devlink/devlink.c | 20 ++++++++++++++++++++
> 1 file changed, 20 insertions(+)
>
>diff --git a/devlink/devlink.c b/devlink/devlink.c
>index 67e6e64181f9..c750ee1ec6d3 100644
>--- a/devlink/devlink.c
>+++ b/devlink/devlink.c
>@@ -6362,10 +6362,27 @@ static int cmd_region_read(struct dl *dl)
> 	return err;
> }
> 
>+static int cmd_region_snapshot_new(struct dl *dl)
>+{
>+	struct nlmsghdr *nlh;
>+	int err;
>+
>+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
>+			NLM_F_REQUEST | NLM_F_ACK);
>+
>+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
>+				DL_OPT_REGION_SNAPSHOT_ID, 0);
>+	if (err)
>+		return err;
>+
>+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
>+}
>+
> static void cmd_region_help(void)
> {
> 	pr_err("Usage: devlink region show [ DEV/REGION ]\n");
> 	pr_err("       devlink region del DEV/REGION snapshot SNAPSHOT_ID\n");
>+	pr_err("       devlink region new DEV/REGION [snapshot SNAPSHOT_ID]\n");

Same as for "del", snapshot id is mandatory. You should not have it in "[]".


> 	pr_err("       devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]\n");
> 	pr_err("       devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ] address ADDRESS length LENGTH\n");
> }
>@@ -6389,6 +6406,9 @@ static int cmd_region(struct dl *dl)
> 	} else if (dl_argv_match(dl, "read")) {
> 		dl_arg_inc(dl);
> 		return cmd_region_read(dl);
>+	} else if (dl_argv_match(dl, "new")) {
>+		dl_arg_inc(dl);
>+		return cmd_region_snapshot_new(dl);
> 	}
> 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
> 	return -ENOENT;
>-- 
>2.25.2
>
