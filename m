Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C64A193B52
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCZIwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:52:41 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40571 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZIwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 04:52:41 -0400
Received: by mail-wr1-f50.google.com with SMTP id u10so6668982wro.7
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 01:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a16268aHXp9rnsUEFlR5VbrAL/wUsnpzmwCUXxiQTR4=;
        b=nTDNqTSP3NsHdNmGrIQinRPBEsIonfcnpfGXsYNf7navh+WgZ1mkwP4I45Auuxf8nb
         GTjjeKMQsaDJbAwkDoqRDkKkBZAwjRG9Or680A2KXBElzEw5D1YskCX8jq06bBHTpgHT
         Y+znLSMvj5+KyiUfkyK6oPsg7bxp6O2aAKlJzVsdjdlluAsZfI3TaMZg56t8mpg8dXlO
         QCpFe2ZT0LMjYjUOaUw/xyc2XacW0MlcK0x7BAMSKsjfpwsbQAN4JoqwMae7GIMiaRt8
         2wPUFjJatqoO5+mkYk/lD9K/koPs2+JL8Uwb8tfbNHb3vZ5mYJuCu2NQnHEeXI6mu3Dm
         M5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a16268aHXp9rnsUEFlR5VbrAL/wUsnpzmwCUXxiQTR4=;
        b=Z6bF7oOTj0hVnsroVovQ8ZXbnIEE28XRFChB/IFrkDiFh0TW1HakUlz6XjTkO55jUr
         b8hLqCdo5WF1AvHEyYwp+uYwBgPUhg1ehi3RdvQMIWtZNM8ZhIOMU68AVv+w62BEd1zn
         szeetOkJ6f5cv9cILUykxn8niU/mslWa/lIBR+m5m4tIOxuPy7+wWKygLHRoTcDyuPXh
         w/slZ4GNWNLar/FLCClr30yCcvvsVebZHr/oXnR/jdKOrHuNRxKJD+1vqaNXX4xQ2LnO
         nVjsZi5M8axAu5ePY32V9CpX5BMvSLKB9DsUYC/C8z4NFC9RF0dA3RMn5180O99so8mz
         emEg==
X-Gm-Message-State: ANhLgQ2lvUyEIUBorWQGdLD/G0VCWcxzjbRik0fDt3rwd/LOPFT7P8Rv
        +/oJ6O4OC3C+MxM/Jxn32oeOMg==
X-Google-Smtp-Source: ADFU+vuuPDWHmJ/i1egcKICM7Z9+LZWvc8sqvOtV33GfGOZr4FUufB1QfZCtu6kH6gUb1gQvkqIsWg==
X-Received: by 2002:adf:f24c:: with SMTP id b12mr7902223wrp.162.1585212760303;
        Thu, 26 Mar 2020 01:52:40 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i8sm2584447wrb.41.2020.03.26.01.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 01:52:39 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:52:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 09/11] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326085239.GO11304@nanopsycho.orion>
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

[...]

>+	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>+	if (err) {
>+		return err;
>+	}
>+
>+	err = region->ops->snapshot(devlink, info->extack, &data);
>+	if (err)
>+		goto snapshot_capture_failure;
>+
>+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>+	if (err)
>+		goto snapshot_create_failure;
>+
>+	return 0;
>+
>+snapshot_create_failure:
>+	region->ops->destructor(data);
>+snapshot_capture_failure:

Eh, this actually should be "err_snapshot_capture" and
"err_snapshot_create"


>+	__devlink_snapshot_id_decrement(devlink, snapshot_id);
>+	return err;
>+}
>+

[...]
