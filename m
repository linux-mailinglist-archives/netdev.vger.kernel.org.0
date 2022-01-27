Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ABD49E53D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiA0Oyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:54:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:59109 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236862AbiA0Oyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 09:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643295276; x=1674831276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HU0r6hwaF27wWadQVn1JhJsILiBLP7WU7Pf4tcjIsig=;
  b=jNxgscSmloMACfnvaWhfH5xyIcIVkGJGjUo8jHHQLuqhNnRVnCsdGNvp
   J6trvcWh7+F2s0PIeTcdJY4L9h7l4HdbI9Kh+QWQ96x2Buw8Yy66ALuvJ
   ld/pJRex1GaxNhNkwFtuwFdPEUA4aJZuLUIvOw3TNzhG5swpLhr167pBr
   tHXfdiJHwwBweGqvzA4Q+TQyYklMBwm7ktkqN1UdzDmeJ4PUSvbHbFRsd
   2NlLBtIcMnKqMYNki6GMMSTxiWaOgG+gPADVwYM/HE2iWsPR8tiRmpe1Y
   VFOIR+HEohDWDW7wTEA2TfqCDUSImfGc94+mDa+wNh7Xsh7xOMLdgi5CZ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246819953"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="246819953"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 06:54:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="625245301"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 06:54:30 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nD69M-00F0yG-G4;
        Thu, 27 Jan 2022 16:53:24 +0200
Date:   Thu, 27 Jan 2022 16:53:24 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 05/13] net: wwan: t7xx: Add control port
Message-ID: <YfKx5B2R12lYW9GZ@smile.fi.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-6-ricardo.martinez@linux.intel.com>
 <7c1f1fe-fb19-fa95-10e3-776b81f5128@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c1f1fe-fb19-fa95-10e3-776b81f5128@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:40:42PM +0200, Ilpo Järvinen wrote:
> On Thu, 13 Jan 2022, Ricardo Martinez wrote:

...

> > +		default:
> > +			break;
> 
> Please remove empty default blocks from all patches.

Some (presumably old or with some warnings enabled, consider `make W=1`
or `make W=2`) compilers would not be happy of a such decision.

-- 
With Best Regards,
Andy Shevchenko


