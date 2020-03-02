Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D48176162
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgCBRoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:44:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39393 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgCBRoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:44:20 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so830469wrn.6
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 09:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fG1GKCWs5iqfivcgrYPevVHQog7cZYfXoHFe7Yq8pkw=;
        b=TyKEmI+TX1ON4gS68pjjWgAyNfelT15+6fqPBk4Lj1DGd9kjIyz4XnudPJZfnz1LZ9
         qWVDT2rW4IesNlU2fvbZJ8f2ImiJ0sljm10U9jMvq59MZVORxqbMNfC9+carNnKyPU6Y
         DlBetlFJEy0RNgQjLWIyQ7i2E+TTj0kj5mzztmnW1QYLXVI2A6RDuZCtniWvV9tqKAR3
         17DUfPGyU4AGKGZdNsxNEkYWOq3ef29DoIP97TS34sg1FJoWWaAph5uB08/CdgPhX3uz
         5gh86/GswWbUO9+1SFmiSAET2KJ0EeYAqcgSa9WwvOUXCizDj6vEZZxLrfb6Hv2B3YQG
         AGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fG1GKCWs5iqfivcgrYPevVHQog7cZYfXoHFe7Yq8pkw=;
        b=bjRmf96gSqzeLvsl9O/F7+/VO7JxWQjeEBHqvGiEDcgpQselKv5LSqYFKDj7G92JIJ
         l059UmqSjusGbNbKVgtkk46zRn4y1jDZPOQxabGGeKXwpo1RsvaTATTVxqbOwDyFLUDD
         Kmn+jsO31E2USIl4AW+tuok5ahUQOvISN3HwoU3kdjxX8IlF001pAaWtW/YDVwjx4OR7
         deCJzUq7nZ2mfni2SDPA0ZZtohMmIVaR66xXlKIaIDr9+YmZg4xXmr++4uiQ5TNm3aTR
         FUrxgIVva1oZ53yiKy4ZTNm8mSlpoFkdnCeay8e6nLPQP3oAG6NBIvTT9CCJEp7yzxWC
         +qFg==
X-Gm-Message-State: ANhLgQ0+w8LcWyLTdzhAAb72a2uT80RY1Uc1z0UGP98aB9abtEzBae6Q
        cN4c4NJZMKTiJaYdKv2qcSFEPw==
X-Google-Smtp-Source: ADFU+vs42mct6axh5KOsrsISfmE77zkCIcM8Mg3Cws7A30fe0knq1jaxL9YZbF7WeRa/F2gc0KZwAQ==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr701645wrm.260.1583171058811;
        Mon, 02 Mar 2020 09:44:18 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id b12sm785834wro.66.2020.03.02.09.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:44:18 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:44:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 12/22] devlink: convert snapshot id getter to
 return an error
Message-ID: <20200302174417.GH2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-13-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-13-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:11AM CET, jacob.e.keller@intel.com wrote:
>Modify the devlink_snapshot_id_get function to return a signed value,
>enabling reporting an error on failure.
>
>This enables easily refactoring how IDs are generated and kept track of
>in the future. For now, just report ENOSPC once INT_MAX snapshot ids
>have been returned.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
