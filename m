Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3488D056A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 04:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfJICJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 22:09:57 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46184 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfJICJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 22:09:57 -0400
Received: by mail-pl1-f176.google.com with SMTP id q24so250788plr.13
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 19:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=x5QS9YyTxW2TslTLHp1CF9GtImU5c6twLEXytaZc4tU=;
        b=EciAH3OP++Zi05xM0kCUGaEzRbBSfXiPVci3RAz+0qVPCQ1msoVlsCktwthAvZAxpi
         0Etrj+OMHKnzjMgqWT0yesGMKopu+5UgOtEm9Mrj+3dn+FfnnEG90lw2CS1nT/5WCFXE
         oXZ6Y7ufyOM3o5B6xiOLeWR4sEKpYODo4osP1EOlVAnA6b26A8p/n2ZMctE0bkW315Df
         h9EljshJdkJOMLPydjv4kAB4iXS3mI9dIN7HMGyRFpD4OL3+YXopdfrp3asLfpkjx7S4
         P47/3wlxKLxXJ9E/GRIagueFgFd5v2BWDWBNvNtyOVDfKYnLHWTVRQ12KVsFtAchhMv3
         SlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=x5QS9YyTxW2TslTLHp1CF9GtImU5c6twLEXytaZc4tU=;
        b=bpFy9oGAjSx/3L/0lPKnyfrsxJGuvfci5mL79FYasTuggOGFO0B0ShytD+/8QtjYGL
         1ZGqQpxnVfYhosDlNRjlvAfrakCM1krute3500X6RR3yG+RT3Nm60E9vOA1CYm2ZeDDL
         nOyshNDSFsn9ra7fX+EVvYKNc6QaWJ18Iq1omTh8VVu/5r2o2oV9Kix0nNlCD3UFCjqG
         nWrqyE5uaQfE8Y2crlvw6y0uJzaR983gQAZWPCYPKEntRQwyxn9x+1NACiciD1VMC40E
         dzrgwehsjfiapw0J/jugYSDEvU9yaqQjq4l5MQ7/UFkWkus2Eo4f/xIlPH7ta0z4dzqd
         hNxQ==
X-Gm-Message-State: APjAAAWGcWEcaaK6bMQhyL/YxFgbZpckePit9PLF38QU1opIad7+ez5w
        27LhhJpGD5qE/u7vXEXVY5yuzg==
X-Google-Smtp-Source: APXvYqygLS8x5faJkeCpDKbJDuvwTpCjllXk4ux1JPom32TXnnKUNheVndDvoatHWoJQCsbBuoE2Mg==
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr698136plr.277.1570586996256;
        Tue, 08 Oct 2019 19:09:56 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id q3sm455910pgj.54.2019.10.08.19.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 19:09:56 -0700 (PDT)
Date:   Tue, 8 Oct 2019 19:09:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH -net] Doc: networking/device_drivers/pensando: fix
 ionic.rst warnings
Message-ID: <20191008190937.3dea1324@cakuba.netronome.com>
In-Reply-To: <b93b6492-0ab8-46a6-1e1d-56f9cb627b0f@infradead.org>
References: <b93b6492-0ab8-46a6-1e1d-56f9cb627b0f@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 08:35:51 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix documentation build warnings for Pensando ionic:
> 
> Documentation/networking/device_drivers/pensando/ionic.rst:39: WARNING: Unexpected indentation.
> Documentation/networking/device_drivers/pensando/ionic.rst:43: WARNING: Unexpected indentation.
> 
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Shannon Nelson <snelson@pensando.io>

Applied, thanks!
