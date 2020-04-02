Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50F19BD45
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 10:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387648AbgDBIFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 04:05:00 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:38898 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387565AbgDBIE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 04:04:59 -0400
Received: by mail-lj1-f171.google.com with SMTP id v16so2240476ljg.5
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 01:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:in-reply-to:date:subject:from:to:cc
         :message-id;
        bh=XQZDDCfqzrHXRzCxBWJnl/aWw3Nw+jAcBp/lGh2mgiM=;
        b=0HPfuqj3MgB7P0rn53IWIK+Ne937bITDv2rsQXN6uCE2BBQebP547iaEHH6dRMSxNr
         4VGUhzqyo7Mg2d0txJgZgjIYwlJyJYY0btv+qNtG61olGOzl1Vj53K+3AwmVAK9KqKU4
         leWabsVJj3bu1+EyFSFuBc91OgVsMWQe910fgBTf9yufpFE+My8EpiS8DWQ/mQn04mrj
         dKRXimrB4mJxEIndN1x07LiRjw0juafqqMHVYF9Yaw9lYXJ5h4d2Er03yCKHVC0YEy95
         eGJV1VisYI7m99Q4v3uM/HWICfb60z1qDYoY8mTB3T2wHVilM+JXsUPxrvIuCstSGqmZ
         v6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:in-reply-to:date
         :subject:from:to:cc:message-id;
        bh=XQZDDCfqzrHXRzCxBWJnl/aWw3Nw+jAcBp/lGh2mgiM=;
        b=OW85U2r+JKv7sz90f2ZYpVI8vQ7RuszoEwuycuPUi2mT/Yka7eybXJepcwOhCIYBVa
         kZKEZ0jeNrbfkrQ/FbX7wmOEXV/ZDl6fNCy38KXC9Nim8hfJmfcEgHcE2wy1cMKIn1K8
         LYwaoiiVGH32fhhpGuRZwGGG+3Wm49+C0xNdrxsNFfGs1eyOx0IBUNH+PkxPpGL+sCky
         GgvPj0CSdiOI0gKaSgMH3DhU4kKd3om3oe7zXQzwuXtURSoMGFbOIvU6701B6vtCGvK7
         04HdFHmMr2vd/lE1ipHYdk7j9Mx92vPA4HqCllQ8oYGmABCVbqq82qu9fZ8KCnOjFzzW
         GYEA==
X-Gm-Message-State: AGi0PuY1fQ8uBzkVe+1Iae1bIUqYLudEPvpVYjJd2VjP2K6wV8CZnlF9
        +qmtxIk/+J3cz29RsUy2YX6t/Q==
X-Google-Smtp-Source: APiQypLfgdVYubZFJtOenRgIER0sqtAl9x94eGBWVWyNDyNHwwuVQtskiKfjjxB/YfaG9A3JbKMmmA==
X-Received: by 2002:a2e:9252:: with SMTP id v18mr1273195ljg.114.1585814691777;
        Thu, 02 Apr 2020 01:04:51 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c2sm3426591lfb.43.2020.04.02.01.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 01:04:51 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20200401175804.2305-1-robh@kernel.org>
Date:   Thu, 02 Apr 2020 09:52:22 +0200
Subject: Re: [PATCH] dt-bindings: net: mvusb: Fix example errors
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Rob Herring" <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     <devicetree@vger.kernel.org>,
        "Tobias Waldekranz" <tobias@waldekranz.com>,
        <netdev@vger.kernel.org>
Message-Id: <C1QK4JZDOZ2B.24IAC4AFLHWP9@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Apr 1, 2020 at 1:58 PM PST, Rob Herring wrote:
> The example for Marvell USB to MDIO Controller doesn't build:

Thank you for fixing this. I did run 'make dt_binding_check' before
submitting, but my branch did not have the latest kbuild additions
which passed the examples through dtc.

I'll make sure to address the remaining comments once net-next is open
again.

Thanks,
Tobias
