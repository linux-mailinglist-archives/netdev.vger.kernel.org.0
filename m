Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47954F25F4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 04:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfKGDY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 22:24:26 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:35006 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfKGDY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 22:24:26 -0500
Received: by mail-pf1-f172.google.com with SMTP id d13so1307999pfq.2
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 19:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=irINuBH0sWnw4TvPRBhn1/G9ZoET2+5Mtj/KReEZL78=;
        b=o4ulapp3VRhN1W7hG1LkEgLhom7i27Qt7vpEJFtjsGVybTEWXVjxwdG4k1ieqD5jIX
         T/t7KFcRO88uOqMlrMOXX/zsYDPlXd8j1RF4w+5yD+IDlJMsDjuV/DrLB0eLd+4QbYg+
         oeEr4Pyyjt56g5xluSAqT/HRthgv40Y/jsWYXgHj1aZAcA+01dRMjy5DjJzanRbipXkd
         azPR6Xw7+5ZBC/jt2UXc2KNGey+LJ4iVek8Rkehx/qnW/Hp5zIrsYJGA/xvdUnreTWA8
         Ptb7OSx3TSPgS6F+KgPdzwBC5Xhmmvoo/oPBXexwhdlCx9VwGtLEaL0/rQqNIolkFyf8
         PU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=irINuBH0sWnw4TvPRBhn1/G9ZoET2+5Mtj/KReEZL78=;
        b=swW5Zke0HDyvzGpKq9EIw0E/LtMNLAofsNDyCVQ+Y+uz1TCuR27uMM/bHWsWUig7jk
         yOjhJo3dg0t6eEf1Z7dxmSJXP94TdAEaSACMqdX+qsxUQ3W4sEnq4PA6rMHMi763aJrE
         ufn/do25sbNmtiKa0qiKBeMkIhgmYlQ49UqyYIKiPWHrq46Y58kMhqlZ59YU8imLCnAQ
         Yisqp4oVnA+Edh++reUbEdht8b9Q8j6h0LyGA8O25GlNUGUly+oZrpjC3mdwI3F1yS4H
         eWr4JcW5Vr43MaE7Ud2ua7Sk86nmOBNKniikXhHuCyQ7ocn4vaj56m5uCKZmfaUQERim
         pxMQ==
X-Gm-Message-State: APjAAAWuUxFRQQnHpz6i4EgP6OfKTI947ydr5aeNAhddgzoMg4D17jov
        UVX8zHEoY7fn7vOy1JcQGfX8SQ==
X-Google-Smtp-Source: APXvYqylMqyzVVNkE0pFEqzUxOaxjl2UwsKpZq8HmMc04wL9xGFBafoS8DmU11X2C63K+oQFTmtNQQ==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr1669241pgi.272.1573097065361;
        Wed, 06 Nov 2019 19:24:25 -0800 (PST)
Received: from cakuba.netronome.com ([64.63.152.34])
        by smtp.gmail.com with ESMTPSA id a34sm450569pgl.56.2019.11.06.19.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 19:24:25 -0800 (PST)
Date:   Wed, 6 Nov 2019 22:24:21 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v3 00/13][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-11-06
Message-ID: <20191106222421.0fb9edb0@cakuba.netronome.com>
In-Reply-To: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
References: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Nov 2019 16:52:07 -0800, Jeff Kirsher wrote:
> v2: dropped patch 3 "ice: Add support for FW recovery mode detection"
>     from the origin al series, while Ani makes changes based on
>     community feedback to implement devlink into the changes.
> v3: dropped patch 1 "ice: implement set_eeprom functionality" due to a
>     bug found and additional changes will be needed when Ani implements
>     devlink in the driver. 

Thanks!
