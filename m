Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526931D9FF7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgESSsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESSsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 14:48:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F279820758;
        Tue, 19 May 2020 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589914126;
        bh=kK0kqRBISFfw+LMgiQjewsoa2uS1JJxjWknCKnBXyK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=riUzHb2BC7TBeldi0x4FutsBzD9QwlWuT+HduP+76h7T8kU+8Df4RtFUYpXuNCQKa
         lv0g2wgL8da227BEb8yOQ5I2To2hdxgpH6FOiAAJBMbRddPF8y+J30QKDzT8v5SPvF
         +UPQgevBUbrIcqwjViyBZ6DoSn4DEd7/gomxombM=
Date:   Tue, 19 May 2020 11:48:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
Message-ID: <20200519114843.34e65bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c45bae32-d26f-cbe5-626b-2afae4a557b3@ti.com>
References: <20200519141813.28167-1-dmurphy@ti.com>
        <20200519141813.28167-3-dmurphy@ti.com>
        <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200519182916.GM624248@lunn.ch>
        <c45bae32-d26f-cbe5-626b-2afae4a557b3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 13:41:40 -0500 Dan Murphy wrote:
> > Is this now a standard GCC warning? Or have you turned on extra
> > checking? =20
> I still was not able to reproduce this warning with gcc-9.2.=C2=A0 I woul=
d=20
> like to know the same

W=3D1 + gcc-10 here, also curious to know which one of the two makes=20
the difference :)
