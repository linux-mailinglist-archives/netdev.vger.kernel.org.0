Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDB51E0FFD
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 15:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403929AbgEYN5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 09:57:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403805AbgEYN5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 09:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GaU25l9pyO7K3XI0B24cqiTiH7sFU/aybUfiy90S9MQ=; b=cJD9+lcJpMXmAgH2bxGoTpihrb
        CesVhtmmnWKMcOJKY8VMvm1FouO5Sxl/A8p19o3l5wXlkeRw8bngaVqik2FyWlv61n3fjIlLJjCtX
        xNxr6p9XGYXxOOMnF0FlJRbzCCcRHKhXTAPQl/+6jGRRoj9HJ1h98BIZRk/uQvdJ1yPw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdDbc-003C5d-CK; Mon, 25 May 2020 15:57:28 +0200
Date:   Mon, 25 May 2020 15:57:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        robh+dt@kernel.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, jianxin.pan@amlogic.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/8] dt-bindings: net: meson-dwmac: Add the
 amlogic,rx-delay-ns property
Message-ID: <20200525135728.GE752669@lunn.ch>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
 <20200512211103.530674-2-martin.blumenstingl@googlemail.com>
 <20200524212843.GF1192@bug>
 <d3f596d7-fb7f-5da7-4406-b5c0e9e9dc3f@gmail.com>
 <20200525090718.GB16796@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525090718.GB16796@amd>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > standardizing on rx-delay-ps and tx-delay-ps would make sense since that
> > is the lowest resolution and the property would be correctly named with
> > an unit in the name.
> 
> Seems like similar patch is already being reviewed from Dan Murphy (?)
> from TI.

Dan is working on the PHY side. But there is probably code which can
be shared.

One question to consider, do we want the same properties names for MAC
and PHY, or do we want to make them different, to avoid confusion?

	   Andrew
