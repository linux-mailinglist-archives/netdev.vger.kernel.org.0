Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F6CD05BE
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 04:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbfJICze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 22:55:34 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:37998 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbfJICze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 22:55:34 -0400
Received: by mail-pg1-f177.google.com with SMTP id x10so437940pgi.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 19:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qE6p286c8/HUKD9YlOpzetQfcoGTOIt7sbmPaMrpQFM=;
        b=ikqUbuR37QdA5XzUpp+vk1gVX5XEx4aQzW5PZSHI0af3USyfZMLgEWrNdHUO2SE2qn
         3LhM907yNhBRpFeRf5uMC8+zpbiCwF73Qme0OK6NUucx7skdVJBE61J2KSep7mIJTXDD
         1kuAC9mpHp/f+bEon9dt36HujveYgknTQjPkJBPNUKytLwvxqdJflb3ziBqF1d7IIhZ3
         R6f8Tz/gn0yFzVO4sixh+HCkE6TBsoBpZ8AFoh48fFFi9bdViECTIKyAjAgeE2PdgPk4
         JxCcRpl7hiJScKbkBlXfdWP1w3oSQileDNedkQWZP3sAPMizlycg7tMj+4ATHD2CHXjS
         0yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qE6p286c8/HUKD9YlOpzetQfcoGTOIt7sbmPaMrpQFM=;
        b=MZccXvCnfw+4qrGVU0O0v21bMEuCjFox/+S0GjMGS0exq956rQLuXzt8P6M1FexMO9
         I15itMOwxn+yOCyAVx/hXRwhbKKH0G7PDZ+ulgL/P2I/N6N3Fkz5iuKltYmwOQDC6BWb
         O+BIshJ1H9NrUi4s1To/HfkV7XdjatUhruyPQ+L/S2Vr233leMnnnDphqOPn+xyytsfD
         b0FA3Bcdz2XB8uD9dYwMAde4oUBzM73cAt7x0OiNfAFqQT5ovzL9wz3XY2K/9fThFbxj
         ox/K04Nh3UesqG4xrXNYIK2aGcJ65kXqN/RLkEYma8/cq/R6E3df88ybn/TYI4PUpphn
         KXmw==
X-Gm-Message-State: APjAAAXr5jQ3H7CVSyIrfzH2iCNC76Rv04dEPjIQ3F/ia3Mekuwtjs9G
        Efw/sr/kBucPgx6nuZ5rjKxeeuRt6Ec=
X-Google-Smtp-Source: APXvYqzE+zjTVtsipvEV46fA9VPQUJtnpAjQbDBrsqhMeYmvE25XQhyp8rbQ+xcrpp7kV5XGmO1UZg==
X-Received: by 2002:a17:90a:34c1:: with SMTP id m1mr1332101pjf.89.1570589732900;
        Tue, 08 Oct 2019 19:55:32 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id k8sm429841pgm.14.2019.10.08.19.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 19:55:32 -0700 (PDT)
Date:   Tue, 8 Oct 2019 19:55:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-10-08
Message-ID: <20191008195520.33532bbe@cakuba.netronome.com>
In-Reply-To: <20191008123111.4019-1-johannes@sipsolutions.net>
References: <20191008123111.4019-1-johannes@sipsolutions.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 14:31:10 +0200, Johannes Berg wrote:
> Hi Dave,
> 
> Another week, another set of fixes.
> 
> Please pull and let me know if there's any problem.

Pulled into net. Let me know if did it wrong :)

FWIW there was this little complaint from checkpatch:

---------------------------------------------------------------
0006-mac80211-accept-deauth-frames-in-IBSS-mode.patch
---------------------------------------------------------------
WARNING: Duplicate signature
#14: 
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

total: 0 errors, 1 warnings, 0 checks, 19 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

0006-mac80211-accept-deauth-frames-in-IBSS-mode.patch has style problems, please review.
