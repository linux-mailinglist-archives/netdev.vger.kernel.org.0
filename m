Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95EC385F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389372AbfJAO7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:59:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44976 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfJAO7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:59:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id i14so9813661pgt.11
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 07:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1V5QfI/L8J6eNMsF0FsrNGhotYK3LpAjX+JuE0/Q/Vw=;
        b=uMnJkP352/y4OStm+52Ouatbv5kCG7wTCYH102ClLs4vM45GKLOKLCG5fSbhmUnysU
         7bUTjfod4vzZvqlKUCbQ8e0lQYI451wuoHChoAAUYyG5tWQBdNStRIRmpCYY9eyFPTr1
         7HuaS62Ojxh53JkK/9iVtUVJNc6unjbKqg2RFzU2V2d/rF9kwjv98NvavVgsdzhGdPou
         PLbO35rVEaZLcnCXnj4dfmfa+ez3TQRgELyx95PfvGq3h9uFca4EOXlsWMw5wvdGSWeY
         wYeGqHYdwNRvuBXyV9689XiQw2KwYH58T8kCDIoMeG6DnM74qscEVv1F0V4QKlvjA3hH
         W83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1V5QfI/L8J6eNMsF0FsrNGhotYK3LpAjX+JuE0/Q/Vw=;
        b=PtUO4DjvnXlec4IFPDWCkQmf/Lbh3G5MZveO94vdFB3B9Uzpooq8QMvTqDs4pKyNs/
         VqSiOCeC2Zfp9Koij5OP2f+1ePoOIVkhf6GMxrUkTh2pWB0KPat5+TaADsdUw+3YVK9Z
         8hvmn8MlDnU6lIJ49e2i71hJ8h/RHhKt3i2IcGqQ51wdYFGRlmemd5YaoARhJ8hVcJl7
         hWVzb6C8NTmC2vFmoUqEnNlbgwrcFEJ5TqU3dfL71KE4PNBrVx2g73lhOUGVBDsA+xqB
         KOj9U1BD7qoV5tBNvhcUXzP3jIVh9Vay3MawWRlco0/wfUuMlO/EXBr/Eot82nFhHpnC
         ccjg==
X-Gm-Message-State: APjAAAWcIJuvsz0FTSTVRTu9SZd+/JqHfSklNz3Mhive5qmmH15Q432b
        8+nKjLI6m6WrfMsNHotkUVdho3w/8f0C6A==
X-Google-Smtp-Source: APXvYqzpsnOWjiJkqK/GZlLzZcI2yqiQjEJWJYUltA2I8X3AjTxRB0l3GS3kyvSwb01IFlcbJgFD3w==
X-Received: by 2002:a63:9742:: with SMTP id d2mr29570708pgo.356.1569941975758;
        Tue, 01 Oct 2019 07:59:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k3sm19784425pgl.9.2019.10.01.07.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 07:59:35 -0700 (PDT)
Date:   Tue, 1 Oct 2019 07:59:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, ivecera@redhat.com,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH iproute2 net-next v3 1/2] bridge: fdb get support
Message-ID: <20191001075928.26f1dd43@hermes.lan>
In-Reply-To: <1569905543-33478-2-git-send-email-roopa@cumulusnetworks.com>
References: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
        <1569905543-33478-2-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 21:52:22 -0700
Roopa Prabhu <roopa@cumulusnetworks.com> wrote:

> +
> +	if (sscanf(addr, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
> +		   abuf, abuf+1, abuf+2,
> +		   abuf+3, abuf+4, abuf+5) != 6) {
> +		fprintf(stderr, "Invalid mac address %s\n", addr);
> +		return -1;
> +	}

You could use ether_aton here if that would help.
Not required, but ether_ntoa already used in iplink_bridge.c
