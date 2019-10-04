Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5ACCB4A4
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 08:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388433AbfJDGzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 02:55:38 -0400
Received: from canardo.mork.no ([148.122.252.1]:47755 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388422AbfJDGzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 02:55:38 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:34a:1f4f:9043:eeff:fe9f:3336])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x946tY3N008985
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 4 Oct 2019 08:55:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1570172135; bh=rQirohiGdJ0Y21jOPA18mYDUWxzcvXyZIir3X8U0PTk=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=RsD1Hr1vWtzpT5GZT/lMJC2ZGrCASau3W4rKclVOUoS9qfbK0hpp2TMBv6TNRmf45
         9ZTOBQmtkXz9ptLfyVjCWneyEkuO8fIRU6AaMaSCmmmcl7RB5Pp5nSo+QOMsgmd0rn
         BXmBlE5w+N5GvWnNLy/fgEmgQLGEXVsp3nFP0Gco=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iGHUu-0001WP-6s; Fri, 04 Oct 2019 08:55:28 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Reinhard Speyerer <rspmn@arcor.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] qmi_wwan: add support for Cinterion CLS8 devices
Organization: m
References: <20191003163439.GA1556@arcor.de>
Date:   Fri, 04 Oct 2019 08:55:28 +0200
In-Reply-To: <20191003163439.GA1556@arcor.de> (Reinhard Speyerer's message of
        "Thu, 3 Oct 2019 18:34:39 +0200")
Message-ID: <87v9t50zkv.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reinhard Speyerer <rspmn@arcor.de> writes:

> Add support for Cinterion CLS8 devices.
> Use QMI_QUIRK_SET_DTR as required for Qualcomm MDM9x07 chipsets.=20

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
