Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D5111960
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfEBMwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:52:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55524 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBMwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 08:52:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMBC8-0000wr-C6; Thu, 02 May 2019 14:52:12 +0200
Message-ID: <e861784bf2bd177494396de0f404f3d8472dc37a.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 2/3] netlink: set bad attribute also on maxtype
 check
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 02 May 2019 14:52:10 +0200
In-Reply-To: <e7a5efb0d4acbd473286a9e5923d1a97c68fcb09.1556798793.git.mkubecek@suse.cz>
References: <cover.1556798793.git.mkubecek@suse.cz>
         <e7a5efb0d4acbd473286a9e5923d1a97c68fcb09.1556798793.git.mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-02 at 12:48 +0000, Michal Kubecek wrote:
> The check that attribute type is within 0...maxtype range in
> __nla_validate_parse() sets only error message but not bad_attr in extack.
> Set also bad_attr to tell userspace which attribute failed validation.

Good catch, we actually do have an attribute in this case.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

