Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359B8115131
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 14:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfLFNkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 08:40:33 -0500
Received: from sonic310-13.consmr.mail.bf2.yahoo.com ([74.6.135.123]:43250
        "EHLO sonic310-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726245AbfLFNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 08:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1575639632; bh=AafIP0Juo+UuxpqcCLTf25EDT+8pdx9CvrNFRoLCjMc=; h=Date:From:Reply-To:Subject:From:Subject; b=oe8SiGVsHlPVCCuNPEb2MsuQwgkXMMAj4znebIKPFdAZ2yLpCdGr8mcL4usdH3iJRlzDI8W4Y+PDs5221klPLF72wj8CnLb0+F2zk41WioVy8YZZWliO2ULsYJtAo89yZbsmDIuKwuIEHn28t+krOQ0pdO8OT9U6t8FMtcMaVXKEA3BsCBFi/uX+JjSP66NlrQ6vEeuagJFUFZ2CfZOv9pxb9ih2NAd996zcZ1S3H1BcugvSutincGQPawJcIkL6rxaEeIK+AUq/kqLvTbBMuKWAOsH+nrGN5Jc1bXIDJ3CBhrfIR0OAV21cBoIZcojZRhtLIvs0n5LhPd/E3FIBDw==
X-YMail-OSG: j55AgYgVM1m0D_uUBZqoLDBZg4zJIbUyyoiJ.e3g0gK5JWTuWBzTP_m9CTy8Vhr
 JBWsh2JEK3B9xnT0BVN3C3rR3L6iB1BgMYrItWxhAzTiSoUU7uxW1HvrXMq.Dch26yRMISvnj0LS
 1n5ETcXO.4b.uEPFwSrBqRgvLEvuhmYLJLLtKPr8hR2gJHrqWnibvtojSzHwFTmo0rv61QfOTM4H
 KnNrLcLnueVGdNefGtZHFbpQm0ryraSTTHvjyhMpv.8tyEd.8R0TZ4xAjSID_KfTy4wQtaNMgqay
 M7P3RhJvWB3TUMX8rvNE7iZPfjEaVrfzWgdR4CcDNJxtZKRnCaGLF_p89vKO4bo4nW7nepjaapeP
 YP.CPoxlPSJAhX46rkw6wDO03YOzeN.t6x_9Be7GDkss8SxSqGCQHteTUuclBnQ7hbkKeJ7Nq_a9
 0a6h09tfZWRnP4BooDoKFpsz0M_GQxDl9GhgPyZfdA16hBA4gW_tYak.sVjuPPuT07HmTicQDMt4
 RB43lCwsWREnhnVMPHGZAhHf5l_kQ4LqrnCFxyXLcqQuZ5A7KlThirOi4kwkv8D6WBLEJy.C07sk
 zcKkuxAo8YjBkeYb3OkF2jB017_mWNU4S3QlCoJZ2cfObbUVK.S77Up7iy4jGsos7aYpZxaKoNWq
 B5o4guTJhJ1sOebAAhFsDgGPRsjGCfmJzuqkNAFkdNWDyVnqYQ1R3GTd_7ThVJ2KxFQMnmwkTJYg
 deL3kEpeUe0qevynjIaPBDLKcGjeQy62xFUufcHkpLw5q9WrUqzx1Vff4LHRruIC0L7xizsNAvAs
 GeARt87RF5wz2y2Sj9AkHYKsgAsv.cMjq4at2zvcnjsAQiMmPVHxmkBusAlimOOS2_0EMiGQTBb3
 .egsdTctNz_oEC4ryKqjZKUNm_EsHdAPOc4SwF2y5i8mrscNqfbJZkpxcIEVN.sUm9FAgT9EXqXg
 yZRKTpcPHmr2JIly5HRvCduK8IEB8T4rBplMTdhod31f37UurA1LxQjEsSG7Uw.RMzWaqrG_fEyH
 VQeOG_E7oNgR7vl0krNnfm5yNWEqP_Re1c96nRIkSMEZosvL5vLDYdlL0_AbXLbd9JJIpuOFiLgn
 aKslBphvAJlrKnpX9WS_g1mujOpwjmx6M1ImrjuckO71ZAdO7naVPIvtHzCwicgG3pP7ixRwN16Z
 yaSx8jkb4EguIhMdjlQnUNvDOgro8tfX2rFEg4zrzXfuMx8HSxyvkmj2JKykmgiPtBf_b.mnRyFT
 2wODFMRBn9ReF9fglumCh_Ic8xwtYTHajdbfa2sIhp5i4X1ZXBvOmWuoH0CyWq5ToZ_nK0s6oMw-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Fri, 6 Dec 2019 13:40:32 +0000
Date:   Fri, 6 Dec 2019 13:40:28 +0000 (UTC)
From:   Ali Hamadu <ali24@gmx.us>
Reply-To: ali106@accountant.com
Message-ID: <1588713771.6389485.1575639628417@mail.yahoo.com>
Subject:  Gooday To You,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



 Dear Friend,

 Please i need your kind Assistance. I will be very glad if you can

 assist me to receive this sum of ( $22. Million US dollars.) into your

 bank account for the benefit of our both families, reply me if you are

 ready to receive this fund.




