Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8AD1F968D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 14:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgFOMcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 08:32:09 -0400
Received: from sonic315-20.consmr.mail.ne1.yahoo.com ([66.163.190.146]:40121
        "EHLO sonic315-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728598AbgFOMcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 08:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592224327; bh=zI0m+DRhZDm01EKX+YHsQU600DuE8AwybL7Vu4lblwE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=TMP+x4gjHwkAyt+RLNuATXyTnuF5yLcGR4byIb4KhIjK3CK3Kti67ewrr6XVe5Oxa9vkApWVm5abk0Gpjc/3iP9BRXUYjp6LJaLZ6QAMJF8CZTm9yWzD8hZBvk8kVspCfIWPaZndAxiKaolQoBVU3m94YC3t9NNL1H5NDt/nH9EIu0ylapYgtcSgiYHwHxSGbOwosZ0/xquAGNV2lKlL1Df9sz9ynnu1/osYcDk07qO1sKYgo5xxbsfx/TejRI3m2K4GyzOn4P/LZFBQeIgAbVkgJvTovmA6tTyBWHZFFpQDKpK4B2tM1OYkl7G1N8abWOEobwjhlmqCUDAWApNOcA==
X-YMail-OSG: gif8yHcVM1n0wYZTMhAWm7kgnzJiYCN.esrfwpag403Gm6fkLBkuLGkA2PQdDU7
 rMvUH99_QVnZAwbcPLnYAmvuLjDAXYYW2S8IboMwzYLhcDnT90x.CvGNcT6xq.89S1riSx.sK7C5
 L1iHpQheJ4S1_DerKidy.FuJhgL3P73LPXz8jkNhoiIM5opw5qdOf6jcZYXDs7osLxi1tGesVnze
 YWAl4q_z2ysbsJRejZdvdiqFVAj_7pjIBNKNdxWdVEVkImMKcC2cTXU0iMuD7IUBUX4fFqWPTkhu
 SdyGJfjM1KmuAq1Tdflc.90X9JcScRCj.o8e8K56.raI6gFe96VfQL8hv86Bud4C6cdWNFCgT83p
 YFEvkrxVPMq7M8EeqqHjidS0wz3dQmlQxwlkYe5n.61PsGBaqQbtQXMip_.oruHcidJ8CDLxYXOi
 QJF9HjaQlpG5iRca6_F5XkftQAAoaRW7GAFZZoGas4FuxP7vNi.wjTSpkQu__V2Jqew9grEhf1mX
 JNvifNbwaIJKqK5h5LfWxZ6ixpIOQYsRKdu1ZoiUuDnaHvhAFERcEbNhAzIajsHT8aONJj4CXtWa
 EivmaSJdCsxmor0naFh9fpch45T6QIK2M7Km6LxXTrkTcGtW6AkHRUWBe.F0XOTyZa48jDd.EPcK
 cPzMJTIcSV9uHLBAk.jYaKFMzk_b.Bgs3u9.TmwHrmjfAk2yoUq6htON2uuJPl5TiNYj1DklFAG5
 OGoBpc_NjG1LDevMA9R.F8FSU5F1pmblvey5x3hUhD8eWAvIYmRIIdMQ_jPTSpdl78AHRqyWmM1a
 D7K1piY_wl9YBS9IsOJ8Yfw6IwKWetikkyaL0J8DhbKWOby9BOq1ZCIGEUmthHK4zSJ.dbFU6VnG
 8jVTFveR61xZYBNmfs00bUuQK4v4uloJ7Ik6G8lLvmbpe7t8tQe8uYPUnc2NkHdHMju3iYAOKBv4
 i3k6VnERklTYWtdeRXM3sJFNCc0kPXSZ7Gdzn1s.dOwOXrdS.5PAxdeAJnrQLFTvdresrNx37usI
 B95sBGfW0ENPyreesNkOOoJE_wzYSCOowtR5LDkpcBmEA_cIs__uOfIIC1R5XN0PYryCHSpcTXrG
 MN9XUuqL3qeauJHzbw_VaZ13PeW5Ynq41fhK6I.kZNr4mrXK52srJE4Yw1iy5N5.5WgRDSfY5uEH
 ZN14903Wbbd_KMX_AWFObgJbHhGUBiaUNgP3.RQtKXXkiCAeMFrwdKuOGbkdA0fPjH0swdAVZhRG
 yt67qsvDSElubytHx5N730z13FQxW_zensn7haOsksnrk.NSkjGE64HJk1Az54Eekul9iAf._NaV
 QEns-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Mon, 15 Jun 2020 12:32:07 +0000
Date:   Mon, 15 Jun 2020 12:32:04 +0000 (UTC)
From:   Lisa Williams <lw716542@gmail.com>
Reply-To: lisawilam@yahoo.com
Message-ID: <1727543764.951746.1592224324796@mail.yahoo.com>
Subject: Hi Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1727543764.951746.1592224324796.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16119 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:76.0) Gecko/20100101 Firefox/76.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi Dear,

 How are you doing hope you are fine and OK?

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us.

Yours
Lisa
