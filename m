Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01754961BA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381479AbiAUPIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:08:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbiAUPIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 10:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AOVmtBe4RfIqVuDW0D+ERxuFvcpmqncFVJBF/BDMUXk=; b=ChtKe0MmluGG5FF4W+UXy8vVB2
        d9SzbNPIkM4WjCRNk/+vjm1pBriDbNnAp7HnFhiD9MuZdj2jLma5qV7OgjG5QegoOFDB1HaVbFPhZ
        EBMtlTUfeAM82dXwPu4BXbESUqQ/981mQv+idDO3+vpV/oJFG3L2SKQeKf7VMj2tsgvw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAvWx-0026BU-Cs; Fri, 21 Jan 2022 16:08:47 +0100
Date:   Fri, 21 Jan 2022 16:08:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YerMf2wl7KSLpx8Y@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch>
 <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
 <YeqwyeVvFQoH+9Uu@lunn.ch>
 <CAAd53p6C5SsYwKt4xsJ+qiqhrF45UW_VG8O+EiJcgeWy=MqzPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p6C5SsYwKt4xsJ+qiqhrF45UW_VG8O+EiJcgeWy=MqzPw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The Marvell PHY on the system doesn't support WoL.

Not technically correct. The PHY does, the way the PHY has been
integrated into the system does not.

But again, you need to think of the general case. Somebody else wants
to make use of this feature of not touching the LED configuration, but
does have a system were WoL works. What does that imply?

     Andrew
