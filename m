Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E10162D63
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfGIB07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:26:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45984 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIB06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:26:58 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so14818294qkj.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/kIJ1MVfUiSeuT3sFd/kLyiJdLEUQX0Coh7kegfQiqw=;
        b=BIlPVV1yNUNlf816jCJoJZCoMFX5lLIHpK8iKLC01lvnUoc+u7U+1D5CzvV+/FrDQA
         LB97eAJdr8NXJskk6qRp4CDyHuzINdSb1Hx9bZlUDgEi9PA2X8+4sArf5wSceAobd9Zn
         EV0i7tkd5344Rgk2EW1UBQsQxCng1b26bDOV89SInTCf3P4a+GEIADuH2Woi7+GUHoJQ
         cYasP3bJqS8mRrjigFVPWVpP6lFJIYsCc7Z/TawugIsvMIPkAHEFPNjWpQi48mMrj5IR
         B8Ym8vuq24+tFkLX0z6mubIYxlwpdgIDD/Ttv/0Zd/gWJI4cxunAJSCjlUmJYbp/16L2
         v1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/kIJ1MVfUiSeuT3sFd/kLyiJdLEUQX0Coh7kegfQiqw=;
        b=PC8QsBR9E9eK6p0459wj+JwN1i+JPmfm28Z6E7wQfH6hp5SbZtwGkzzhTLO4CC+FRz
         g+rQ5sk6xXr/Y8vUkxX2206GWi8H/DfvRlts7/oKfKL8i6yMfskMXyWS64666YVQZE9g
         yYaG35cTPf+vUj/ThZ5Jiq5m6b7wPK2nOrSV4epwEX1QMA8sZCFGVkZtq+NJ5C1Rs/12
         /9xSlYb1GfSYhA2lXVoxMHLVMyhvNQRDkmt/Zc/njf5dlnUlqOh7PLkD9ylMMkOyIj/o
         vBZ3sNAxTqb+xRx+2cgChpXvlMzxdRuM3r+fVC1NkEZ0/02+yqXAiKnwAqIXCMxVC+0P
         RCcA==
X-Gm-Message-State: APjAAAVHSFKlrVLAi0+WJYd/naSEFpbyQNj+51xMuY9GL2xH1XQK8766
        LE5QVtZnKHwlIJL8BM3f21BGPfnNJFk=
X-Google-Smtp-Source: APXvYqwC5ZCqdWhnAZkcpj8CFHs2BoUMjgO1YVPY8+hAJrgXgXNGZ4yLKp1aFaG46rWjEdP3avUKuQ==
X-Received: by 2002:a37:a94:: with SMTP id 142mr15179974qkk.89.1562635617898;
        Mon, 08 Jul 2019 18:26:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d17sm7929508qtp.84.2019.07.08.18.26.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 18:26:57 -0700 (PDT)
Date:   Mon, 8 Jul 2019 18:26:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
Message-ID: <20190708182654.72446be5@cakuba.netronome.com>
In-Reply-To: <20190708192532.27420-20-snelson@pensando.io>
References: <20190708192532.27420-1-snelson@pensando.io>
        <20190708192532.27420-20-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Jul 2019 12:25:32 -0700, Shannon Nelson wrote:
> Add a devlink interface for access to information that isn't
> normally available through ethtool or the iplink interface.
>=20
> Example:
> 	$ ./devlink -j -p dev info pci/0000:b6:00.0
> 	{
> 	    "info": {
> 		"pci/0000:b6:00.0": {
> 		    "driver": "ionic",
> 		    "serial_number": "FLM18420073",
> 		    "versions": {
> 			"fixed": {
> 			    "fw_version": "0.11.0-50",

Hm. Fixed is for hardware components. Seeing FW version reported as
fixed seems counter intuitive.  You probably want "running"?

> 			    "fw_status": "0x1",

I don't think this is the right interface to report status-like
information.  Perhaps devlink health reporters?

> 			    "fw_heartbeat": "0x716ce",

Ditto, perhaps best to report it in health stuff?

> 			    "asic_type": "0x0",
> 			    "asic_rev": "0x0"

These seem like legit "fixed" versions =F0=9F=91=8D

> 			}
> 		    }
> 		}
> 	    }
> 	}
>=20
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Isn't this a new patch? Perhaps you'd be best off upstreaming the
first batch of support and add features later? It'd be easier on
reviewers so we don't have to keep re-checking the first 16 patches..
