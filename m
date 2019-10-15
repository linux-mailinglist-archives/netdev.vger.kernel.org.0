Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EB9D7F96
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389271AbfJOTIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:08:09 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37554 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfJOTIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:08:09 -0400
Received: by mail-wm1-f47.google.com with SMTP id f22so216770wmc.2
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 12:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3wsColzhwzCA30mSrpJqLKN5DqcLh+3W4XIzaK4868A=;
        b=MY4G5eOw1DGwFE9ENDvR5g6LKZpJ4TcV9Bf0GKN0cpjdeSlGCo1rMHj9YPmuh9bdbZ
         MVlBhAVEq3SnZTNGlFkgxdpeVsGY0vWyqjHFVNTnqMSm5c592F77RFQql0xqdcqS+LtE
         NK6MnningY94si+ukERvPJTww7N00qHOt0IkWoOpwn9EWur9sWAIhw37c+wcrSvP1BMT
         hO09/BF3Af0UKlqLpc7Oh9OpW9MDY3fN2sxO3QtvRJ8kdlp1leJ1hdO6v4hQbdHi6qV0
         ofI+uqARh1S9HzO77NXTGlKw3X8QFC19CrdofJtDFcX4/ORxNM7pxAZaZYGq8VPtDCZE
         FOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3wsColzhwzCA30mSrpJqLKN5DqcLh+3W4XIzaK4868A=;
        b=jcU1F7bXZ+fCaevznYkGSEsMSzFlbkZxMj2QxAV9h8UOfMiSpjIcgY7HHKKa2T1K48
         +biyYLpwOqPN/FyYwyYGRWTuBUdfyNF/oizJlLI7brCNoSoYVtkxxEo1zdsQMY3HhekD
         0XPs7lM9NdcZU3ZmQek/BHX7w2EkQA31Yj+MjVxOLWPN0YFIn7vAoWxA40j07dhCLOSn
         qK5CtLs1j0ceidOnbjJ8zFlSV+j6P2UX+BuMM5Uy/WXQ3O9EFsy6hV8xeXz13ax7OXPS
         MnARA5vN6oV8qwo+MMw6LX/pVNnkbnYWfmUqivXZ4vt1Yj2WrYfkuzt8YR2fCs1BermM
         ka9w==
X-Gm-Message-State: APjAAAUDdgWOlAk2Cmx3aaZxBay9b/BqKrOpYsxEeWp2W1n0nNHvpNIp
        6TYjdaxp9n3rM7aA78M20LCa6w==
X-Google-Smtp-Source: APXvYqz9hEvbJTXQtZky94Ejlh4sTJERL4UlWP2CJDKzQfwzeFtwYf/dliMDqLO7vVj/YmJZTm+rIQ==
X-Received: by 2002:a1c:a8c7:: with SMTP id r190mr1381wme.162.1571166487694;
        Tue, 15 Oct 2019 12:08:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b5sm122861wmj.18.2019.10.15.12.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 12:08:07 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:07:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 0/2] mlxsw: Add support for 400Gbps (50Gbps
 per lane) link modes
Message-ID: <20191015120757.12c9c95b@cakuba.netronome.com>
In-Reply-To: <20191012162758.32473-1-jiri@resnulli.us>
References: <20191012162758.32473-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Oct 2019 18:27:56 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add 400Gbps bits to ethtool and introduce support in mlxsw. These modes
> are supported by the Spectrum-2 switch ASIC.

Thanks for the update, looks good to me!

Out of curiosity - why did we start bunching up LR, ER and FR?
