Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05354A6E6A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245728AbiBBKKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:10:45 -0500
Received: from relay5.hostedemail.com ([64.99.140.38]:35087 "EHLO
        relay5.hostedemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiBBKKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:10:44 -0500
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A2342304B;
        Wed,  2 Feb 2022 10:10:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf20.hostedemail.com (Postfix) with ESMTPA id 8BB4720032;
        Wed,  2 Feb 2022 10:10:41 +0000 (UTC)
Message-ID: <90e40bb19320dcc2f2099b97b4b9d7d23325eaac.camel@perches.com>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pkshih <pkshih@realtek.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 02 Feb 2022 02:10:40 -0800
In-Reply-To: <20220202050229.GS1951@kadam>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
         <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
         <20220202050229.GS1951@kadam>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.52
X-Stat-Signature: a6iseiq8hnmqaizdxdhrz3te8wu9jjme
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 8BB4720032
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18DU2nJGrtl7nrzKyQf5hu1M0xTgVU9im4=
X-HE-Tag: 1643796641-41319
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 08:02 +0300, Dan Carpenter wrote:
> On Mon, Jan 31, 2022 at 02:53:40AM +0000, Pkshih wrote:
> > On Sun, 2022-01-30 at 22:37 +0000, Colin Ian King wrote:
> > 
> > When I check this patch, I find there is no 'break' for default case.
> > Do we need one? like
> > 
> > @@ -226,6 +226,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
> >                 break;
> >         default:
> >                 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
> > +               break;
> 
> No, it's not necessary.  The choice of style is up to the original
> developer.

every case should have one.

Documentation/process/deprecated.rst:

All switch/case blocks must end in one of:

* break;
* fallthrough;
* continue;
* goto <label>;
* return [expression];


