Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47C3EA7C6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfJ3X3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:29:24 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46121 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfJ3X3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:29:24 -0400
Received: by mail-pf1-f181.google.com with SMTP id 193so1509292pfc.13
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 16:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8biiWttzGpiJnXnMlCZ01+F4RZ66FQIm3dsoJJY1LoY=;
        b=bMwmURPJZW57XM+QQpqoR6BpEbUYb8jKR1GBDZAcSfUKRa58qn22C+fQUdnEKEBJaA
         3jC62vwIDqFGhbVxqCjzE+I084k9yWp1/52wJw8WtUpsWIjX3g6kzBTpVvMpVv+DdCWr
         +3Fgx+RS7TDhAJK1scpjO92Cm8StYBsl7AG4JADXygFSshGL1cKERysgA6y90Rfs4rAB
         oIipaLmUW0kUd17bWCILLcc1FXZ+jt/SkZagMlY+78yVZLGE2HHaGvabHTq81t18QQx3
         FT9MoNQbqwf/NIH/+GmV0VPtHzWjrF78LnxR367jGMx9BMt9AI+hX+7gp1NPT2tKTy0i
         2UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8biiWttzGpiJnXnMlCZ01+F4RZ66FQIm3dsoJJY1LoY=;
        b=WKoBJubg1kv1bDYN9+JNmX4woC0pjniTkCPSYgMQ3/RgrxL15b5Nwmiglz+YEDz9Sr
         RfWxse/W82O//D0W99/ABlkTpYCAVwEgvfj57/lIDH4J/yqDMNT4FEW2mLxknP63PSWS
         xfK4s/rl8VYMu/MnuBXwFWz0j/zp8hIGvhSyjaHkpq61bQ1koB6P7p/fcpHyXiHnqSHb
         y1qb/KtjeLGBVJFK2oZ3YzPAdp3Ln9ST3FYLn1zSnQs5Z2iwNI2Qlv2lxAxHA8kzblZD
         esWZ2cTyeFG491wbFLQ+pQnsvR80gkhoh4NL5zpVkv3WnwCA/Lakjpdb8PG2dnBc1W8L
         2QrQ==
X-Gm-Message-State: APjAAAW9z9SvbSDPYw2dZabUrZGo/cx3rRHzQoK4VUIsr87XJ6hK5FKa
        ySSEGznnZnzIdrl+WkAalkcZrg==
X-Google-Smtp-Source: APXvYqxM61dPN+/sruIgd5xHJlfAqHu0u7niHw7DB1TSSWwL8xEYC9CRGf9BnrJFf2GL1pR8YJe49g==
X-Received: by 2002:a17:90a:9406:: with SMTP id r6mr2570175pjo.0.1572478163342;
        Wed, 30 Oct 2019 16:29:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 21sm1047768pfa.170.2019.10.30.16.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 16:29:22 -0700 (PDT)
Date:   Wed, 30 Oct 2019 16:29:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH 2/3] ip: Present the VF VLAN tagging mode
Message-ID: <20191030162920.3ec8549d@hermes.lan>
In-Reply-To: <1572463033-26368-3-git-send-email-lariel@mellanox.com>
References: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
        <1572463033-26368-3-git-send-email-lariel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 19:17:32 +0000
Ariel Levkovich <lariel@mellanox.com> wrote:

> +		if (vlan_mode->mode == IFLA_VF_VLAN_MODE_TRUNK)
> +			print_string(PRINT_ANY,
> +				     "vlan-mode",
> +				      ", vlan-mode %s",
> +				      "trunk");
> +		else if (vlan_mode->mode == IFLA_VF_VLAN_MODE_VST)
> +			print_string(PRINT_ANY,
> +				     "vlan-mode",
> +				     ", vlan_mode %s",
> +				     "vst");
> +		else if (vlan_mode->mode == IFLA_VF_VLAN_MODE_VGT)
> +			print_string(PRINT_ANY,
> +				     "vlan-mode",
> +				     ", vlan-mode %s",
> +				     "vgt");

This seems like you want something like:

		print_string(PRINT_ANY, "vlan-mode", ", vlan-mode %s",
				vlan_mode_str(vlan_mode->mode);

and why the comma in the output? the convention for ip commands is that
the output format is equivalent to the command line.
