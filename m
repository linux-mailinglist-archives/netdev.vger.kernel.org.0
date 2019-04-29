Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E165E40B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfD2N4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:56:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfD2N4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 09:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t8uYriH1Ulb8wHNzLAO92cq2lN3geSiBkvBoqlgIHcI=; b=DBZci4iiASJElu0xP4RzoM3YHQ
        3+dZlUMYrsdk+RP71wzV3bOk1RwxqIj7Vg8WN+4Ri9+YPti79D2PO9py/g40G5hnfKJsxM9FHn7vN
        KcEFTmUM5rpX1SrpMPDyaIGBl6+fYrpXnitYvLElfXd+P6rlTCNPHYe6CYZe6lu/090I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hL6lH-0001Pp-Jx; Mon, 29 Apr 2019 15:56:03 +0200
Date:   Mon, 29 Apr 2019 15:56:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: Fix inconsistent
 IS_ERR and PTR_ERR in cpsw_probe()
Message-ID: <20190429135603.GI10772@lunn.ch>
References: <20190429135650.72794-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429135650.72794-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 01:56:50PM +0000, YueHaibing wrote:
> Change the call to PTR_ERR to access the value just tested by IS_ERR.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Please could you add a Fixes: tag.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
