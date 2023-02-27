Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12756A3631
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 02:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjB0Blt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 20:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjB0Bls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 20:41:48 -0500
Received: from antispamsnwll.cedia.org.ec (antispamsnwll.cedia.org.ec [201.159.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8CD2113E6
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 17:41:46 -0800 (PST)
Received: from antispamsnwll.cedia.org.ec (127.0.0.1) id hvg55k0171sh for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 20:11:09 -0500 (envelope-from <prvs=14220f090f=phernandez@cuenca.gob.ec>)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cuenca.gob.ec; s=cuenca; i=@cuenca.gob.ec; h=Received:Received:
        Received:Received:Received:Content-Type:MIME-Version:
        Content-Transfer-Encoding:Content-Description:Subject:To:From:
        Date:Reply-To:Message-Id; bh=4Q8sM1WnLl2+Gbtb3rrOkEcuzcuZBE8iv+H
        DJ7a/1zw=; b=hp1B8EaQFyb3GzWVCYZMQk8i3il6X7H27+V83L3WvBgwbqHYPpb
        Ddi0SdZCV/vdIoXmxrF9+LCafgpwiyFvieMjQIFfy6V0LVTjcIKCRYei034l0rwW
        fpO7UiHBSVmd4D6/OADwZXNbh7Jy6iRH0wg34UkVqdIOXngu9pnx/2FI=
Received: from mtace.cuenca.gob.ec ([200.55.234.131])
        by antispamsnwll.cedia.org.ec ([192.168.205.200]) (SonicWall 10.0.21.7607)
        with ESMTP id o202302270111080008622-2; Sun, 26 Feb 2023 20:11:09 -0500
Received: from mtace.cuenca.gob.ec (localhost [127.0.0.1])
        by mtace.cuenca.gob.ec (Postfix) with ESMTPS id 514864426F7A;
        Sun, 26 Feb 2023 19:48:14 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by mtace.cuenca.gob.ec (Postfix) with ESMTP id BE4A146365B1;
        Sun, 26 Feb 2023 19:33:47 -0500 (-05)
Received: from mtace.cuenca.gob.ec ([127.0.0.1])
        by localhost (mtace.cuenca.gob.ec [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5ouU9yCTe512; Sun, 26 Feb 2023 19:33:47 -0500 (-05)
Received: from [10.20.18.117] (unknown [156.146.63.154])
        by mtace.cuenca.gob.ec (Postfix) with ESMTPSA id CBE7446373AD;
        Sun, 26 Feb 2023 19:13:47 -0500 (-05)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Investment proposition
To:     Recipients <phernandez@cuenca.gob.ec>
From:   "Franklin C. James QC" <phernandez@cuenca.gob.ec>
Date:   Mon, 27 Feb 2023 01:13:37 +0100
Reply-To: franklin.c34@aol.com
X-Antivirus: Avast (VPS 230226-10, 2/26/2023), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20230227001347.CBE7446373AD@mtace.cuenca.gob.ec>
X-Mlf-DSE-Version: 7077
X-Mlf-Rules-Version: s20230112191048; ds20200715013501;
        di20230221222152; ri20160318003319; fs20230223174059
X-Mlf-Smartnet-Version: 20210917223710
X-Mlf-Envelope-From: phernandez@cuenca.gob.ec
X-Mlf-CnxnMgmt-Allow: 200.55.234.131
X-Mlf-Version: 10.0.21.7607
X-Mlf-License: BSV_C_AP_T_R
X-Mlf-UniqueId: o202302270111080008622
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_MSPIKE_H2,RCVD_IN_PSBL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [201.159.220.42 listed in wl.mailspike.net]
        *  2.7 RCVD_IN_PSBL RBL: Received via a relay in PSBL
        *      [201.159.220.42 listed in psbl.surriel.com]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [franklin.c34[at]aol.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I trust you are staying safe and well, I am Franklin C. James QC. from Glas=
gow, Scotland. I have an investment proposition for your consideration and =
more details will be revealed once your interest is indicated.
   
Yours in service,
Franklin C. James QC.
____________________
Secretary: Phillip Hernandez

-- 
This email has been checked for viruses by Avast antivirus software.
www.avast.com
