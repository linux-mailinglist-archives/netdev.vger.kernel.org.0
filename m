Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457D31398F3
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgAMSde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:33:34 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40159 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgAMSde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 13:33:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so9672006wrn.7
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 10:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oRAvdvhDyzdot5sAEYL3BsF80/aDZCcq9jPlzCrasZQ=;
        b=bUSOMfCL/LWklXYEKE7qWnLnYbsdQWJz8gmJ/NRGMyQwGmcTQgb5KLmyqxg/OhN5Zv
         WopnR+RMIaxtgTHAp0Das5pkXHBtmJskMtpDCMhCM3sPtcGQAtqHtgtAbfVsJNXlyy0G
         eyoYhSBbg1/+6oqY1kY/iKEBVjCNmDCOXAfAfpbxjWYLS1lixCH3IMEQnKxIGE47wB4r
         8v7/pyn2hU3KQAsJqIngIY6Urdp6UEV/jeG0nLUPTfDJ52lcYHfd90egyx0s/XI0BjuS
         xtqRkWXS5KMnXOHinOt2epzk9iTWHwR1U6XSHsAo4UAk0fQacsWias/yxOP682BK6Luz
         gI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRAvdvhDyzdot5sAEYL3BsF80/aDZCcq9jPlzCrasZQ=;
        b=B+kxAuB0NeiHeXxXQ6X8hLP36Dtm+p3Xe+7zqjmEKOg0ZMXROCpuuVwDc5rLpWZRMA
         fo9wrgdlfvdqWHzXSyoV4eXAW4g/bJ2dXBSnx+wQOzZyhOYLWXU3ftgPuL2EC83J7xMp
         I8ZRMw9Ek4InlYZcV0pqZuYJMHNcwX0en9DIajXXcFSCxI4Fdtzz6rFRqsTfUGeGggEv
         7pTRwgsf0YO/ovL1Dy+UQthX6Qv6LbEQvK0GMPLQ/09GuIHuauUU/zLmOddfT5Pvu6Nm
         KJEXffUSkrffYHQihZhKrN01QrNtKxk9tKwbGOIlZP79Hq8/cRUY1YO1i0yp3qJK4pox
         12BA==
X-Gm-Message-State: APjAAAUG1eCwa5/pSDKEIf7Bv42l/tuj5v0e2nACVfUzZ6vMlu71Zv0I
        vtMtczZbMgpasVSvYJqr7RxK+g==
X-Google-Smtp-Source: APXvYqzdBd2vuZ9kFNRJl+EqS58bEV1UICphyoRA7W8IldwNUBuRFrzHVZmMS0eo2vmU7ucsxOPwFw==
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr20829982wrw.25.1578940411859;
        Mon, 13 Jan 2020 10:33:31 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id e16sm16193729wrs.73.2020.01.13.10.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 10:33:31 -0800 (PST)
Date:   Mon, 13 Jan 2020 19:33:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        valex@mellanox.com
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200113183330.GJ2131@nanopsycho>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200113165858.GG2131@nanopsycho>
 <1771df1d-8f2e-8622-5edf-2cce47571faf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1771df1d-8f2e-8622-5edf-2cce47571faf@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 13, 2020 at 07:22:57PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 1/13/2020 8:58 AM, Jiri Pirko wrote:
>> Why? That is the purpose of the dpipe, but make the hw
>> pipeline visible and show you the content of individual nodes.
>> 
>
>I agree. dpipe seems to be focused specifically on dumping nodes of the
>tables that represent the hardware's pipeline. I think it's unrelated to
>this discussion about regions vs health API.

Nod.
