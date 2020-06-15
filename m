Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A61F1FA3F3
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 01:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgFOXMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 19:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgFOXM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 19:12:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4585EC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 16:12:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 23so8530364pfw.10
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 16:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2v5+IMS2mI7OuCJYk9zHXTZbS+jY61FdmaCg5pbhRVA=;
        b=nOSFzpjqvBzPfh6ocxO19nQhdrpkF3xyaEwFEFxoj2o+55DlpLseEKBXXif2X8FwO8
         VfdpN1OhOKgEhwnGNwOXUC+k1TxtwksgvZ1V4Et0eAoxOLsBrV/sHexGdiugZWp7u6Yp
         nDdPR7Ri0s8krIQeS1YEirXRjgXPFtxuD6wrA/kHg3jsitZ4WLvrODilgFrJyZ6Tse4R
         d5NT/Gkaa1FMSOdlRIXoURD9hVeVc2QUGdPb7DXkLx1mVwnHv4Cs/KAqZtqdn1oyDat3
         zOA88O1hnm2s6/d6iNFUOG5z1K2tCefLcbF+AHmpiLM6JQdfHU8JaBlxlkobDuqDClwY
         1C6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2v5+IMS2mI7OuCJYk9zHXTZbS+jY61FdmaCg5pbhRVA=;
        b=VxHo+y84IJhBsJaJuLHqy7UM1F0OfgeztxgEOSlwXh2XHftw9fPxfUTiw/aLW1RUUF
         tKzfao+QKpe94J2jkLGN9SWepOz4pRKBMpwr1A0wPxYrT374d8KJ6iS1XfDCjNYeSnKT
         DTwBgzRaik8Jzy5eEVn5W5d6tSwuhKtKoJbjcvdgpJsCI06jlzfWvxPrZpIclv1ajVV9
         zaS/aq4+Q/KuqCQBr1jy/PGEK10NYbHTSR9Eqth9EFY8QJVJds8Ks2pudDcr4R2d6qL3
         soneubX3UraYBdnGBfojsaPyuHLxw/hjA2OWnHCcySjK8fHCbgHijb4MNMWlBdbHhso4
         5Egw==
X-Gm-Message-State: AOAM533HQdnY36eMEVw/6ATg8HWOuouxKk2FYxkLqawysT8g18yfOdL6
        uI4JUnNAm6IxVgAc5cGWBgWR0mcDcW0=
X-Google-Smtp-Source: ABdhPJxxKJjQXTPv/vgjXj/thDrSAVwx6Ez0VTgQJlnk+aNcyz5dNCVTwy5ZR1puWECGgHYJmHc/bQ==
X-Received: by 2002:a63:931b:: with SMTP id b27mr6066115pge.135.1592262747741;
        Mon, 15 Jun 2020 16:12:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h17sm12406621pgv.41.2020.06.15.16.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 16:12:27 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:12:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: qdisc: filter qdisc's by parent/handle
 specification
Message-ID: <20200615161219.23d15ed8@hermes.lan>
In-Reply-To: <20200615192928.6667-1-littlesmilingcloud@gmail.com>
References: <20200615192928.6667-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jun 2020 22:29:28 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> There wasn't a way to get a qdisc info by handle or parent, only full
> dump of qdisc's with following grep/sed usage.
> 
> The 'qdisc get' command have been added.
> 
> tc qdisc { show | get } [ dev STRING ] [ QDISC_ID ] [ invisible ]
>   QDISC_ID := { root | ingress | handle QHANDLE | parent CLASSID }
> 
> This change doesn't require any changes in the kernel.
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>

The idea looks good, but you need to conform to the kernel style.
Look at these checkpatch warnings.

ERROR: space required before the open parenthesis '('
#210: FILE: tc/tc_qdisc.c:397:
+			if(get_tc_classid(&handle, *argv)) {

WARNING: else is not generally useful after a break or return
#214: FILE: tc/tc_qdisc.c:401:
+				break;
+			} else {

ERROR: space required before the open parenthesis '('
#224: FILE: tc/tc_qdisc.c:411:
+			if(get_qdisc_handle(&handle, *argv)) {

WARNING: else is not generally useful after a break or return
#228: FILE: tc/tc_qdisc.c:415:
+				break;
+			} else {

ERROR: space prohibited before that close parenthesis ')'
#292: FILE: tc/tc_qdisc.c:478:
+	    || matches(*argv, "lst") == 0 || matches(*argv, "get") == 0 )

total: 3 errors, 2 warnings, 182 lines che
