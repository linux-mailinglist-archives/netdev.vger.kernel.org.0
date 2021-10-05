Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9856E4224F9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhJEL2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhJEL2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:28:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F00C061749;
        Tue,  5 Oct 2021 04:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=yXyjrs+qRyg3miUfwqFVVGS7bdkhv6JEtbu14uoGH3o=;
        t=1633433174; x=1634642774; b=Kd6H5KMEyXmphHmqPvexQlhg+y5NXCeuZDThSmUW/H4ofq/
        089Vb8Gbmxkaaim8peW1hS562fH/yxtXdueZdZV4DkBSJ3IVI6PPbJUJXo9AyLJCBZPZ+Wu2eNnPv
        ywNG6edK29vj3iGhQsKKG0YZ8+55ABCmDbe2rEy2xt0g9h4EThB15wxNr359I9Pp7T9ZW8SbRAUoX
        LpIpcldfJttAfOGaB5Ho6MKbVrMWG0l5L25WTW+MgjVa5AiUO3I0URVx9j4M6uE4bTaLT7wUd7T4s
        WH/YxcTxQ+YzQHQ4ZPQcf5v0fcp6NWOY9BGyeIkGvbVbrGq8N2uf+xstY40eMRGg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mXiaD-00Fryi-Pl;
        Tue, 05 Oct 2021 13:26:05 +0200
Message-ID: <67cac8f7c300397f511bf55253c27d58621bda33.camel@sipsolutions.net>
Subject: Re: [PATCH] [v17] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Tue, 05 Oct 2021 13:26:04 +0200
In-Reply-To: <20211005112246.9266-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20211005112246.9266-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> ---
> v17:
>  - Add Light communication band

Please do this in a separate patch.

johannes

