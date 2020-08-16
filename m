Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7184C245795
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 14:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgHPMaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 08:30:46 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:57011 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgHPMap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 08:30:45 -0400
Received: from keetweej.vanheusden.com ([82.161.210.122])
        by smtp-cloud8.xs4all.net with ESMTP
        id 7HoAkVXhgzsLP7HoBkPuyT; Sun, 16 Aug 2020 14:30:43 +0200
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 2C0301625A3
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:30:42 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SilGI-wkKosC for <netdev@vger.kernel.org>;
        Sun, 16 Aug 2020 14:30:41 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 11F1116255F
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:30:41 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id 84D5D1605E0; Sun, 16 Aug 2020 14:30:39 +0200 (CEST)
Date:   Sun, 16 Aug 2020 14:30:39 +0200
From:   folkert <folkert@vanheusden.com>
To:     netdev@vger.kernel.org
Subject: Re: ping not working
Message-ID: <20200816123039.GA22273@belle.intranet.vanheusden.com>
References: <20200816081013.GC16027@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816081013.GC16027@belle.intranet.vanheusden.com>
Organization: www.vanheusden.com
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL:  http://www.vanheusden.com/
X-PGP-KeyID: 1F077C42
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key:  http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F077C42
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: ma 17 aug 2020 10:15:07 CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Envelope: MS4wfAwagtEcKaN7U+bPOQ46ndITi8f2j5tDrIVLPcrXldtWNP7i7SbuWJn1SRZcYFo5hl48QP6hPBFb8ALq4L34shYRYpsl02dlnJH/aqVJAC/xaln98LkW
 Vl7pgpq9TK5hDgYVVX7JPxR4TpZYiYYVwWYFXzGHXQlmLP/9f+Ai0wpbUWHZYEVhNd2KPrrLc6OUJw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry; my problem.
I had not seen that the ip-header checksum was incorrect.

On Sun, Aug 16, 2020 at 10:10:13AM +0200, folkert wrote:
> This might be slightly off-topic altough it involves Linux, tap-device
> and ping.

Folkert van Heusden

-- 
Curious about the inner workings of your car? Then check O2OO: it'll
tell you all that there is to know about your car's engine!
http://www.vanheusden.com/O2OO/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
