Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91CD772A0
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGZUQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:16:40 -0400
Received: from mout.gmx.net ([212.227.17.20]:57705 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfGZUQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 16:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1564172192;
        bh=pg8zq+CZhNiOEC5sm0oHNvU69LZ40YKxW+JPQuOe788=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=Ex27TQ7C/i6uPBiHt9QlmEWGt0dUnss/cY/qSZrmwDC+4LNfea6+I9Uqba0nZ5VEQ
         +qYBReLvpudtgeOIrELN6GDDiu66/pGeTndomyJpnlQru1gbnglGYjd5iVznGWRLYV
         Bv92CPeQdwAQ04qKfau0sOpiLrqmbLJXNWH4BZeU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.4] ([88.65.58.128]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MKu9E-1hr6dk0noW-0006lL; Fri, 26
 Jul 2019 22:16:32 +0200
To:     linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
From:   Bernhard Held <berny156@gmx.de>
Subject: [REGRESSION] 5.3-rc1: r8169: remove 1000/Half from supported modes
Message-ID: <a291af45-310c-8b60-ae7e-392e73e3bad1@gmx.de>
Date:   Fri, 26 Jul 2019 22:16:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:SivSbK+NTl7kvns1hcjaz6NqweA2reql9s5I0bOwLMVvKMKDnnE
 1wyppjRKRDxNoT3Zx9aiYLutaKTAysRqwUgeFROufbARI2kuowvERDsZn682gjcqlqJ1jGL
 MS5DXQnzgo4FQ6qMjSTDesyemEdVlUY0AvXGI0WzXbjT+rQshlWUFykRhbLB7Zc3A9E2J0E
 VTfGRFsOM3JbLtXYUtf6g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qDVvnRojMc0=:raMaAE+PFOTpvkoLiTlFUk
 TNbWbChcmTyG+A+vCJ6Gz4zDxNsAKrDnJq4Qe7ZpWeLVoou03wxerlZyyVeFbJ00rQDiZ2b4p
 3RzVEFjVqJO/hnlMqpezk/zXVF+WJqzZgFoBQV0f1Jwqr/oVE67ZVfmNEYLPW93zCp20tTwaz
 /dkdvZV1n46shd0WlXJXD3lTF8Ypcai94BcuR/jshqm7BqLQ3p6704ZQu72deG7X4t7IWVQXg
 nBHqX+QH2Z29voure3BiI0UlB5FrWILFe1KyeVojkg3sxbJ/aToDQt6eREUXDed3CsHBJu2TE
 fYcZvhl6al01KtJciYVuPZry2gHLPtYbj9aLmcPuPPHWDYCbzyX+LOG6brgxhkIZdLNpVggnp
 sf0qdLk5EZHreQWN3I/Dr+BIhJHjqSF6MSW3ixhSnxmP4FYNrHx96cj9ELzDY4hPVyFM4BY54
 di0BmWKbt7rlQk1FYDZW1Y3VGxwvd5/8UphIpuk7WOuLQdzjaxpnXvxZo73JxwQaEPBVboPkD
 xF4fLPmi+uBEc6nQVKk7R4mvmTVELKGTZAe1PivXCi4xhENv9CvqeOc6p+2GFgTCRQ7ry+L4j
 p0fDk/28ERA2yNYtU9dBDq8Unpsf8ksKveIVFrXDLskqUMnMY7rxF5zU28CJeBW81PopquK1v
 /TaUeq+GBAH+QklFs+LzoRYk1OvPevIAGX9q8ARahNV/MxGcdEwB2qfX28LzpjywxVmlCVuSB
 iHvbBtfQnu+Btl6G1XI3UDnuFOW63WvzGnPXHTypRxpaLRDJKXr6m3yXVgLIhlNKw3SHLiTJY
 eweYtE1/gIs4gTeH6k01sXUMfD62FwZSPh4QIbofXQT87gAtw7kEI4c14ms2JSWfJ2yJWwj1V
 yseLLIXDKJWiMEueO3mRCFdwROgF7V7bgLZ0G9DQOf213wagR4RD6imsMytrMAHYCbzZYqo/x
 UYlTn7Efe5XTjcUYk8gYY9gD9gQhSfRbLfeIsxuu674G3/al5j4d9EZ00jfmiaD1xknuF4ao6
 97VgTzNAwnY39aP3ukxSoisMU+xnUi4ZWx6/wNnmoA+rYPXT2kAyDA1zt8nvIP0t3j86wjiCI
 q8Uwc5XnIU5y+o=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

with commit a6851c613fd7 "r8169: remove 1000/Half from supported modes" my RTL8111B GB-link stops working. It thinks that it established a link, however nothing is actually transmitted. Setting the mode with `mii-tool -F 100baseTx-HD` establishes a successful connection.

Reverting a6851c613fd7 (while considering the file name change) fixes autonegotiation for me.

Kind regards
Bernhard
