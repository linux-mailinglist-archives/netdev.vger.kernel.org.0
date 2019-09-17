Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211FDB584F
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 00:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfIQW6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 18:58:08 -0400
Received: from belmont94srvr.owm.bell.net ([184.150.200.94]:43596 "EHLO
        mtlfep08.bell.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726201AbfIQW6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 18:58:08 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 18:58:07 EDT
Received: from bell.net mtlfep01 184.150.200.30 by mtlfep01.bell.net
          with ESMTP
          id <20190917225155.DGOM4947.mtlfep01.bell.net@mtlspm02.bell.net>;
          Tue, 17 Sep 2019 18:51:55 -0400
Received: from [192.168.2.49] (really [70.53.53.104]) by mtlspm02.bell.net
          with ESMTP
          id <20190917225155.WYIW21689.mtlspm02.bell.net@[192.168.2.49]>;
          Tue, 17 Sep 2019 18:51:55 -0400
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
To:     Arlie Davis <arlied@google.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
 <20190917212844.GJ9591@lunn.ch>
 <CAK-9enOx8xt_+t6-rpCGEL0j-HJGm=sFXYq9-pgHQ26AwrGm5Q@mail.gmail.com>
From:   John David Anglin <dave.anglin@bell.net>
Openpgp: preference=signencrypt
Message-ID: <df0f961d-2d53-63e3-8087-6f0b09e14317@bell.net>
Date:   Tue, 17 Sep 2019 18:51:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAK-9enOx8xt_+t6-rpCGEL0j-HJGm=sFXYq9-pgHQ26AwrGm5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-Analysis: v=2.3 cv=bJBo382Z c=1 sm=1 tr=0 cx=a_idp_d a=htCe9XT+XAlGhzqgweArVg==:117 a=htCe9XT+XAlGhzqgweArVg==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=J70Eh1EUuV4A:10 a=FBHGMhGWAAAA:8 a=5AqVkEmHKqrW15nwexgA:9 a=QEXdDO2ut3YA:10 a=9gvnlMMaQFpL9xblJ6ne:22
X-CM-Envelope: MS4wfI+Gpp/YVxFu+k72iT20OxkijuFUlV4iufv1Xx6Ahx/i1xfaDy1js4b1Hyg0jiRm3f/DTzouBI2+25wK5JHL/XBRrXp5WnATPXATE8LU8sAFyaususjv ZYFy5xt20tgxYdpR4CzeiPbipsO1L3zRpBtUSLBt9Sw6fy25XfZdmC0gtB2bvaiQpSEpVOyzsVPHOdfOsq39N4mHLOXUwWNVY/6QHDbs9b/wW9CAvyOFt1C3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-17 5:36 p.m., Arlie Davis wrote:
> Likewise, I'm at a loss for testing with real hardware. It's hard to
> find such things, now.
How does de2104x compare to ds2142/43?  I have a c3750 with ds2142/43 tulip.  Helge
or some others might have a machine with a de2104x.

Dave

-- 
John David Anglin  dave.anglin@bell.net

