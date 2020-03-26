Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835D4193B4F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCZIvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:51:07 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44454 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZIvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 04:51:07 -0400
Received: by mail-wr1-f51.google.com with SMTP id m17so6629440wrw.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 01:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0PPUXfTifGPE0cotKfDXIRnWHPMrwvvGXOxmhfaJGy4=;
        b=XVxpfAZH82vTmjjkJj6mEQZesJy/hljZire59Z/azqu1fdncd9oWK/u8/IEY5r4FaW
         GeS9S0Jv9Ch+TxhfFHt/5T2PZ30zllbYlKhWILsApwZ33csa6LparG4iFjKBK/qOFvuj
         7j1w4gMdQMQDSq0PVdQasTxXRneZfrAACEfjrZcUke4DuUB6J8bPZOWK612UjkKeX1Pj
         VJIfHjA5wgYbYMfV4iQu7VsqXn62sEq7G3b+rYK1TVkiGUrt/Mv4S454mpjIPyGQVvf4
         eZGSu1jNy7wrrED76Go+uAuWvLfdHY9FWvR2gcw4bVjr6rTjknJVDWQz2f58Pc5TM3oz
         EEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0PPUXfTifGPE0cotKfDXIRnWHPMrwvvGXOxmhfaJGy4=;
        b=LPOpNLPJ8f4N0CRa94FPX2nMEI527VVAFyqtggXtl9IJuPiKqtDGMEcaAfB0IKqI46
         31hs68RTcBq37KgzCD6FDy7QgimbbXDv+cVGeh5rlh45KpXUb7fTccrI47Jj98PHMP93
         uA4ZmvF/5l5RBuABQvVsR9g3yMluBNVZppqFX8Pt1mlem/nVWpQlbeiHpUAcKiwiP0va
         prbnCbUqon3LTuhmCzyyRWyZ0tc+yy61eTank/Lbdwaf9SW1Fs/+WMpZpJrRlnNUveH3
         CncjOkIhlo4FHZv88rcV1ABSGwIg+tSLt/TGXhz3naan8CPJmtKd3u3KJQOKLY/LqK6F
         MKyA==
X-Gm-Message-State: ANhLgQ3FOFRCEhotYWbj/MAjYCsXxTYsurT+aDqQOVdUVa6DmLYH/DLV
        ALnTACEzVR566nr7S5hrPqKOGQ==
X-Google-Smtp-Source: ADFU+vvh5xP/h2weyoP9j/CqzLnlBXnIPe6VJkq2wLhPRxpfsiz2U62XLYw5OlJsEaIsg0JPvWguKw==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr8549526wrw.41.1585212664516;
        Thu, 26 Mar 2020 01:51:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y7sm2890479wrq.54.2020.03.26.01.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 01:51:04 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:51:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 09/11] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326085103.GN11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-10-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-10-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:55AM CET, jacob.e.keller@intel.com wrote:
>Implement support for the DEVLINK_CMD_REGION_NEW command for creating
>snapshots. This new command parallels the existing
>DEVLINK_CMD_REGION_DEL.
>
>In order for DEVLINK_CMD_REGION_NEW to work for a region, the new
>".snapshot" operation must be implemented in the region's ops structure.
>
>The desired snapshot id must be provided. This helps avoid confusion on
>the purpose of DEVLINK_CMD_REGION_NEW, and keeps the API simpler.
>
>The requested id will be inserted into the xarray tracking the number of
>snapshots using each id. If this id is already used by another snapshot
>on any region, an error will be returned.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
