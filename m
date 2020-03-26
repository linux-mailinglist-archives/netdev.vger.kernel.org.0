Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977B7193B16
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgCZIgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:36:18 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38151 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgCZIgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 04:36:18 -0400
Received: by mail-wr1-f49.google.com with SMTP id s1so6638954wrv.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 01:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qYbV+PaXddesZUdHpEgCsPKfs+/GfP7aF+R6IS6wOO0=;
        b=LH1HLrooKl5UwFfEBtPqbnQgf7trVMskzM+nTWNuGNUOGULAMO5HRsvqnrlw8DEK9p
         7Sg6EuZKflNuQk5rbA2f3Bx1o4eGlBPRwma74gC/Tn3hM7wm+xq/nKbVdcHEc01R7Kp9
         +XMwHBCnmdwZw13/KdN6iP0imfVZLboiruPEZ2+DxQU9rX3q9CXUZdEafk2YMZDP0FIS
         Eq0YOgkT1WwF83gVbmsnZyPled5T6z2ubBv3qXxVqM6NLkvAazl3XKZLM6eOSRvEFwwP
         Gdd+WmtuH7SM3CVa1GjPL+c8hm9kobyEi72MbLEYfX1bvZpICReJ+0n6hIuaqszuMVLL
         CY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qYbV+PaXddesZUdHpEgCsPKfs+/GfP7aF+R6IS6wOO0=;
        b=GTqYJOwRLN7C/KG85I1eSmKwFDV83PHlgNMEaRb0kMwd0PAsHuHh4zE5lvnSvFge/x
         B0TkgPHQ/iacvAm3yuEVWYNRZIf4/G85/8Ar5OaaADYV0JEaknORPCqc1RLN9BGzxjRz
         dFQfw75E9rv9PzPDssyqSDntyfUOble9uhsMOOgzZHPlZGnz9YvQQ3N96qGaSszb6OC6
         SVjOpoIeyM5cflVx4U49YDAFHhxQgWxFUxBGqMaaRect+jRyzedsqr67JsjCG94bAfD4
         QgCdlxKcj/kuRdQRbHBcXDOZkiVka1IYn8DwZnYMvev4csgRFBm6p9HtwSLfHQwpUrh/
         GSUA==
X-Gm-Message-State: ANhLgQ1MTmlrX6uJIWmr91djjETNkcPcDHdZ+Z6qXV/RXVYdpw09/P+x
        UpT/7PCiAze/61aM21MA0mVdw9Kf4FE=
X-Google-Smtp-Source: ADFU+vvBRdiblh07y4oNcZfFdphTEOkIMvb3lxf2hl5LEZL0hJ4CUSwR51lHahTwdnHT2aXQ/aYJLw==
X-Received: by 2002:adf:e345:: with SMTP id n5mr8476689wrj.220.1585211775432;
        Thu, 26 Mar 2020 01:36:15 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l8sm2560984wmj.2.2020.03.26.01.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 01:36:15 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:36:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326083614.GM11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re subject. Should be:
[patch net-next v2 00/11]

You are missing "patch".
