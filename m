Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFF1D2BEA
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfJJN7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:59:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35884 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJJN7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:59:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so8054358wrd.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2WQZBYa815qI+SGRD60IQB0uLSUfBk1gmVJVi+Ixn+I=;
        b=dW1SUYjqNQUkj1Kq9vEEnarMawZv45GBhVCsNi/ARDDgLoeFUmWmw6464Ny+DZItty
         T9tVLIdRgKQ7SUzXloE2D1cuhE+OpynyXYveyB1GJ2MUNMkXSSp71XT+BSv9tOPHjRiH
         SLZIFItbrMx/GAwBkbKuzWyQwIqCb99SX/cjFGIDgs1BjMW1PxjNiiwxa/teDmBFC0uo
         PfxuXU3aXCWlOsbmuO7E0UTInelYaNh4BF6Wuw7DgQrggI7Lyyyf1if/cyOhWiWKaRil
         0BhGNTvWl7vSv1CB/1vrz3eEjU7PNit1756qrm1EGl83NG/E4FOY90uSQs4YXEoXt4he
         OMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2WQZBYa815qI+SGRD60IQB0uLSUfBk1gmVJVi+Ixn+I=;
        b=cP2dM3oNCAJmvQ0fVE7jeSp6KkfbNvIWdMsqOLD8f1KJkWfss//xRxaRdKrJ7w1slb
         BIDSKVyQwEWuju8z7lP3TXqvpwTTBOfxJadSmoIhWwkZ6m0L/7vKFDXwndU5Ul18ThN2
         w6vr6oY2WXmYvDeI4U9Zk0zyv+BrRpVD7UHouOjKfwC4qyOo8oS7Hg7DMqzcQh9ntuGf
         RWpFZolNDJtxhoQ+THw84I2lh17iIECO2FCB6FATzyZwkS82kVN9zYg5JduL7520ZjXm
         wIHEdUP/r2Zxkavk0Q/m1J5untjpzOLPo8MKY+dQhfUo/WPtG4ZrxuIsBCE+QExV1p9J
         FyyQ==
X-Gm-Message-State: APjAAAXBq1tS8R0oTCW0UCKwQR4Zv6L3iEJ8M/jTwFedzylGXaovCbyc
        WGMswizZFZydJ5KoBnNbggn/dQ==
X-Google-Smtp-Source: APXvYqwB88rdETd7uewu+ZbWl7jywalr3zZGgmDMbF4pGb0EI/J5hyeworGvOimAulLSaWkMKU4tew==
X-Received: by 2002:adf:f4c2:: with SMTP id h2mr8884694wrp.69.1570715958919;
        Thu, 10 Oct 2019 06:59:18 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id w3sm7889355wru.5.2019.10.10.06.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:59:18 -0700 (PDT)
Date:   Thu, 10 Oct 2019 15:59:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 10/17] ethtool: provide string sets with
 STRSET_GET request
Message-ID: <20191010135917.GK2223@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <62cb4c137ea6cf675671920de901847d1d083db1.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62cb4c137ea6cf675671920de901847d1d083db1.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:30PM CEST, mkubecek@suse.cz wrote:

[...]

>+const struct get_request_ops strset_request_ops = {

I think when var is leaving context of single file, it should have
prefix:
ethnl_strset_request_ops

[...]
