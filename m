Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12197C9D1F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 13:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfJCLWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 07:22:55 -0400
Received: from sonic314-47.consmr.mail.ne1.yahoo.com ([66.163.189.173]:38748
        "EHLO sonic314-47.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729304AbfJCLWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 07:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1570101774; bh=VR9WF1YmJWEBgGgfrk6sifTBQtQr9CNcn/HfEAUrPxw=; h=Date:From:Reply-To:Subject:From:Subject; b=RKYYhHaU4Th73LGE3KFl+elX12FvctLNSHw5LZ5mmYF++opu6aelyAEpsYL62DpT78NCohXkFKxnazdTS/nSDk3SFJcCOE22lmlJ1BTpC+Ge4L0g8cnsoNRSEiwYwpWvb4zJsr7GokTjN2uIspEJ3XiVBRLQZWouKO3jyV1vbuUk4A3dL7h//Z60My0IxlirwitFuVrliwhITTbzSd+wmcC/F7tqAXs6IsVWibO0K4bj6GQd+mBaqmnCCSbnf8pHr7ewR//E/iQaHD6DmFrQApuPB/AFZ7bnfa6U8SlOSgI/xoHvv8bRSV1lkbKjHHKJeEepuT/iuEauRikW7s51ug==
X-YMail-OSG: SLOgMYoVM1n8aKfDbB4uflI_LOzhjZRZVaiLPNqCFQy0fJTnbZktIOSETBXxkn8
 Y50y7W6L.1rpu13vClv0SavfksQTO2Ogmp_wVsfomkf.lOQA5qFxZqYIW0NhPx62fc4weFtJvgiG
 9sJXNhYgHLKj7JbN_.tRACwzLHPOpQNzZjEjHATKVHwYeGS8qwYXJLaMskh3sSy.rOJOP4uswLM5
 5OjII7V_OjAI0LPEZbdDaHi_GI5_ba_nl_xtmQXfqQLxQu.cORqj8Rrz76MAOKiHmYIot78jQ3ER
 EolOWgVtIqk8fXpwy6FaBWQ8BxFslJ7BmF0.p_6fEjTZrcfza63xlolgUe7.Vx7gCZsPcA6C_12I
 ibGoDTUVdj_lc0BwLbWw3UmnGA8Foiahbn5gWzQKSHwPuFuLqVGh9lnmDKuUuvklvRuB75MyfpS8
 bHnMPfA24l3uuCtI7H6BNTYCKjKTX0.olqYo.CgQLRfDHDnrZ2W9q8zLn7l4IGW1O.lFI7Urod4X
 V3JHsjAJ.u7p75azMpp5C4gR1tGTbPRAqO7jxFwLFC0tAV0fRjEVRQGX803JxqhzztsJSRdVM5i0
 LSG355Za3GEaqtcqfT8ETSfRlTPVok08h9apUcV2oRnBFb_n.xArbcROd9T9lFBOV2cuDCudcv0e
 gZHWn2aQ_19L3m5YT6CrIyO5W.3Y3Wjo_OH4DtMw91_kPnnReZvQtzIcXBAnaTSBLAbeNoiRcdbD
 Rw5AiFukbytD.kYmoNXYMlIDefT8OYk3M7_3kUQLtuou496NXBGtdLCFhUuDvXvN6UhbGSKk2ulY
 CzcmgZ9aPcNvr09YGiKvt6sWfAgpR5M8PKR0E7HQRcUlyQg0oTAb7JopiDvRiVzS7ypu25o6cTRO
 4ovA5gYj87K14hFNNQYTBvDzuHmteFcdZhlrVPIhqub6xWRal30ri8T.3wH3.2mHWZggMCsiQwhc
 Akp8GRKoeENxVlnenknpLSERKcXWd2RlDXhlcYPVfpLtp8vFmYZ4IDVV7A1QWTuXkZxTY.vtqQen
 YAUtLxWKVaLhicjwbStEE9prOyGSWicw98YvbRQuiG64zB9WA56AEG5ZKwWL3uykPgbNa_Oon0hq
 pd5lbHpmOTzvqKMpHwxzirBpBtlGFqf1hNQscGjBrAs23WfghfcnO50c.wG0Lr_tBXwGtlHspnZu
 oQ6qAog4DZLcyfnvP6HcFidJIcszjDb77XHJSWzoyi9Z4N2VzNkJPmpvvD.95P6pONtA_VQ7BPZ8
 DL8Ar2sKdbLwWkgemyJIurYejpkjxzBItUmCPy52w6alNudaA9DbwdmcC6cs2Prb6PhH7jS1W1nl
 9fyiGlC7ItCEyCI8n
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Thu, 3 Oct 2019 11:22:54 +0000
Date:   Thu, 3 Oct 2019 11:20:53 +0000 (UTC)
From:   Ameira <amdeyiameira@gmail.com>
Reply-To: amdeyiameira@gmail.com
Message-ID: <1912079648.3057900.1570101653223@mail.yahoo.com>
Subject: HI
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Cze=C5=9B=C4=87, nazywam si=C4=99 AMEIRA, znalaz=C5=82em adres e-mail w Int=
ernecie, jestem twoim przyjacielem. W nast=C4=99pnym e-mailu skontaktuj=C4=
=99 si=C4=99 z tob=C4=85 ze zdj=C4=99ciami i bardzo wa=C5=BCn=C4=85 dyskusj=
=C4=85.
=C5=82askawie

AMEIRA
