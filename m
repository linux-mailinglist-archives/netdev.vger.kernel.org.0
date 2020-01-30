Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B32814E0B6
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 19:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgA3SYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 13:24:09 -0500
Received: from node.akkea.ca ([192.155.83.177]:57316 "EHLO node.akkea.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbgA3SYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 13:24:09 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2020 13:24:09 EST
Received: from localhost (localhost [127.0.0.1])
        by node.akkea.ca (Postfix) with ESMTP id 2F2884E204D;
        Thu, 30 Jan 2020 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1580408337; bh=3E251MH06Dbd00638c4EBWp/OLDF5tixRqh+0dV7y5Y=;
        h=Date:From:To:Cc:Subject;
        b=oQGW8Lg5T8UqWMQ6eEYb3z3rRwCySG4i2NpDkrYlh84RT5yII8Lf9yfevBBtmwGZQ
         bBJM1LvXYK658qeWhIcRfZ1NqFP0P2U57NDH7Lkxk+yPDYpXaMid7DKQtcrMjN+l0C
         5iaKf+luLCDePSu3DM64SB7eqr7KxNDSUWAQxO+4=
X-Virus-Scanned: Debian amavisd-new at mail.akkea.ca
Received: from node.akkea.ca ([127.0.0.1])
        by localhost (mail.akkea.ca [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E_-dYhpVuoUL; Thu, 30 Jan 2020 18:18:56 +0000 (UTC)
Received: from www.akkea.ca (node.akkea.ca [192.155.83.177])
        by node.akkea.ca (Postfix) with ESMTPSA id A899F4E200C;
        Thu, 30 Jan 2020 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1580408336; bh=3E251MH06Dbd00638c4EBWp/OLDF5tixRqh+0dV7y5Y=;
        h=Date:From:To:Cc:Subject;
        b=RC66mL6wBnh9Vxy0M/T7tGydF5dz1qCANrAqG7zJstzjEI9eIDVOp98MXKF1yCgs5
         B03dUfyFBmv+H6XlpVFicPR9EAjDimNQ0XLAovsl4hg5kOXOToOW3Hhug3I7O54hyX
         DyADWx5DX40SttywcQZ4hbp+5civvmf+cZ2FenjE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Jan 2020 10:18:56 -0800
From:   Angus Ainslie <angus@akkea.ca>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Redpine RS9116 M.2 module with NetworkManager
Message-ID: <59789f30ee686338c7bcffe3c6cbc453@akkea.ca>
X-Sender: angus@akkea.ca
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm trying the get a Redpine RS9116 module working with networkmanager. 
I've tried this on 5.3, 5.5 and next-20200128. I'm using the Redpine 1.5 
"rs9116_wlan_bt_classic.rps" firmware.

If I configure the interface using iw, wpa_supplicant and dhclient all 
works as expected.

If I try to configure the interface using nmtui most of the time no APs 
show up to associate to. "iw dev wlan0 list" shows all of the APs in the 
vicinity.

If I do manage to get an AP to show when I try to "Activate a 
connection" I get the error below

Could not activate connection:
Activation failed: No reason given

I suspect this is a driver bug rather than a NM bug as I saw similar 
issues with an earlier Redpine proprietary driver that was fixed by 
updating that driver. What rsi_dbg zone will help debug this ?

Thanks
Angus
