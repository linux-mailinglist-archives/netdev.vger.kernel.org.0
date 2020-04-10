Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5502F1A4A45
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgDJTTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:19:23 -0400
Received: from edgy.0l.de ([80.77.16.234]:46760 "EHLO mail.0l.de"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbgDJTTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 15:19:23 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2020 15:19:22 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EB51A3870F55;
        Fri, 10 Apr 2020 21:12:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=steffenvogel.de;
        s=dkim; t=1586545954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hj9dxt8A/WL5SlQvPcaTPHpw6ANCHNOxpeRSRvJgYiU=;
        b=qkONYYYcpy6BcWWbwyRVlTrep+XFhm/oYHbMikbUANv1qB+MuI8A3h3nTs6o1+FH6KCrnP
        yT6O2pGw70aR0wg7Sx1ELkEeWUvK+7XATcOpzwxCR+hrtx+9xyyYN3ab0p5zJM69WDyWPy
        qaDHnqGgST9dNd+1DdXl840riBZChZZXM96swjhNYJmvaoij0Xw+24p3valmi5srz6GPIk
        rM6pnd9uJ2RnTQ+4fupW5T7tfWpriy9ZMZIGmE+tkA/TtkQx8bGb5akdLFkv2N6l/i/9Fl
        4Jkr+OwRPM5dpCmE6uU1hjR8C7bLxfowXrErvC8Bcpda5Ry2RwUpkbgoDKp/Kw==
User-Agent: Microsoft-MacOutlook/16.35.20030802
Date:   Fri, 10 Apr 2020 14:24:53 +0200
Subject: Manpage: ip-rule(8)
From:   Steffen Vogel <post@steffenvogel.de>
To:     <netdev@vger.kernel.org>, <shemminger@osdl.org>
Message-ID: <658522C8-F153-4D2E-87A3-000BC18DE639@steffenvogel.de>
Thread-Topic: Manpage: ip-rule(8)
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear netdev mailinglist,

I found an inconsistency in the ip-rule(8) man-page:=EF=BB=BF

- The synopsis lists: [ pref NUMBER ] as the argument to specify the rule p=
reference
  While description only mentions "priority" as the keyword

- The [ not ] selector is not documented. I am wondering which of the field=
s it negates?

Best regards,
Steffen Vogel


