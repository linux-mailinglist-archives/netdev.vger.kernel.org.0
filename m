Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2884621CB
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhK2UNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:13:14 -0500
Received: from sdc-v-sdnmail1-ext.epnet.com ([140.234.254.212]:60662 "EHLO
        sdc-v-sdnmail1-ext.epnet.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232577AbhK2ULM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:11:12 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2021 15:11:12 EST
Received: from sdc-epwebmail1 (sdc-v-epwebmail1.epnet.com [10.83.102.226])
        by sdc-v-sdnmail1-ext.epnet.com (8.14.7/8.14.7/EIS8.14) with ESMTP id 1ATJujS9015735;
        Mon, 29 Nov 2021 15:05:42 -0500
Message-Id: <202111292005.1ATJujS9015735@sdc-v-sdnmail1-ext.epnet.com>
MIME-Version: 1.0
Sender: ephost@ebsco.com
From:   support@ebsco.com
To:     info@soblex.de, stephanie.evans@phe.gov.uk, cktech@ckgroup.co.uk,
        pharmacontracts@ckagroup.co.uk, nicole.poole@csiro.au,
        aguimard@ckqls.ch, sfarrow@ckgroup.co.uk, math4mat-search@epfl.ch,
        yueling.seow@tandf.com.sg, irjournal@uw.edu.pl,
        editorial@open-research-europe.ec.europa.eu,
        linux-acpi@archiver.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        andrew@lunn.ch, arnd@arndb.de,
        77eed.1635317102.git.yu.c.chen@intel.com,
        9110e.1635317102.git.yu.c.chen@intel.com,
        35715.1635317102.git.yu.c.chen@intel.com,
        47b8f.1635317102.git.yu.c.chen@intel.com,
        7519.4789817107293464743.stgit@warthog.procyon.org.uk,
        7519.6594360917661719152.stgit@warthog.procyon.org.uk,
        519.11215118047756175525.stgit@warthog.procyon.org.uk,
        519.13954182746095781120.stgit@warthog.procyon.org.uk,
        519.14706391695553204156.stgit@warthog.procyon.org.uk,
        7519.8649368675533788865.stgit@warthog.procyon.org.uk,
        519.17630241595380785887.stgit@warthog.procyon.org.uk,
        7519.2951437510049163050.stgit@warthog.procyon.org.uk,
        7519.8303891885033763947.stgit@warthog.procyon.org.uk,
        7519.5910362900676754518.stgit@warthog.procyon.org.uk,
        028190125.391374-1-mmakassikis@freebox.fr,
        jwoithe@physics.adelaide.edu.au, hmh@hmh.eng.br,
        astarikovskiy@suse.de, rjw@sisk.pl, linux-cifs@archiver.kernel.org,
        linux-cifs@vger.kernel.org, mmakassikis@freebox.fr,
        019153937.412534-1-mmakassikis@freebox.fr,
        019083641.116783-1-mmakassikis@freebox.fr,
        16235715.3469969-1-mmakassikis@freebox.fr,
        15130222.2976760-1-mmakassikis@freebox.fr,
        joe.keller@futurenet.com, luke.filipowicz@futurenet.com,
        it.rubelsaiful@gmail.com, maria@oleg-avilov.ru,
        mac.browliamaillard@gmail.com, donald.e.kemper@gmail.com,
        wendel.dennis@sthenryschools.org, scott.broerman@vtigers.org,
        mu-admin@obdev.at, contact@titanium-software.fr, xld@tmkk.undo.jp,
        den.denden@yahoo.com, joshua.garnham@yahoo.co.uk,
        evgeny.br@gmail.com, gb@birke-software.de, rxw1@protonmail.ch,
        josefavaughan@worldnet.att.net, gerd.j@adslhome.dk,
        kemal.kazan@csiro.au, wangyi@cau.edu.cn, rschan@cau.edu.cn,
        greice.amaralcarneiro@natec.unibz.it,
        magdalena.walcher@schule.suedtirol.it, sanja.baric@unibz.it,
        zarei@jahromu.ac.ir, dbarfield@rvc.ac.uk, nccic@dhs.sgov.gov,
        isabella.breda@heraldnet.com,
        parentlink.challenger@howellschools.com, marciel.stadnik@ufsc.br,
        yellowfriend90@yahoo.com.sg, isoken@free.fr, miked@networkm.co.uk,
        bobbysokhi@hotmail.co.uk, abilitylocksmiths@yahoo.com.au,
        cocotaso01@hotmail.co.uk, vyshensky@mail.ru,
        baps1000@hotmail.co.uk, marrykwok@yahoo.com.sg,
        missmillion@live.co.uk, gabriellux@hotmail.it,
        liverpool_ere_95@hotmail.co.uk, matt.friendshuh@norfleetgroup.com,
        molly@plan.design, collier.cheyara222@gmail.com,
        kristy.estes@teg-tx.com, humberto.friede@hafcoservices.com,
        holly.dekle@setboundaries.com, leandra@lt.design,
        norma.brito1@gmail.com, rudy.delarosa@mervalconstruction.com,
        joan@topio.design, alan_murray01@yahoo.co.uk, showsend@gmass.co.uk,
        ajay@iquipu.nl, ajay@arena.tec.br, fabricio@mydomainname.com.br
Date:   29 Nov 2021 15:05:43 -0500
Subject: Fat Removes and Protein Bars
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q29tbWVudHM6DQpIZXksDQripLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLUNCkFmcmljYW4gTWFuZ28gaXMgYSB3ZWln
aHQgbG9zcyBzdXBwbGVtZW50IHRoYXQgYnVybnMgZmF0LCBzdXBwcmVzc2VzDQpodW5n
ZXIgYW5kIGNyYXZpbmdzLCBhbmQgaGVscHMgbWFpbnRhaW4gaGVhbHRoeSBjaG9sZXN0
ZXJvbCBsZXZlbHMuIEl0cw0KdW5pcXVlIGZvcm11bGF0aW9uIGlzIGJhc2VkIG9uIGEg
bmF0dXJhbCBtb2xlY3VsZSBjYWxsZWQgcGFsbWl0b2xlaWMNCmFjaWQsIGFsc28ga25v
d24gYXMgT21lZ2EgNy4gVGhpcyB1bmlxdWUgZmF0dHkgYWNpZCBoZWxwcyBmYXQgY2Vs
bHMNCmNvbW11bmljYXRlIHdpdGggZWFjaCBvdGhlciwgZm9yY2luZyDigJxiYWQgZmF0
4oCdIGluIHRoZSBib2R5IHRvIGJlDQpyZWxlYXNlZCBhbmQgdXNlZCBmb3IgZW5lcmd5
LiBXaGljaCBtZWFucyBldmVuIGFzIHlvdSBzdGFydCBkcm9wcGluZw0KdGhvc2Ugc3R1
YmJvcm4gcG91bmRzLCB5b3XigJlyZSBnb2luZyB0byBmZWVsIGdyZWF0IGFuZCBmdWxs
IG9mIGVuZXJneSBhcw0KZmF0IHRoYXTigJlzIHJlbGVhc2VkIGZyb20geW91ciBjZWxs
cyBnZXQgY29udmVydGVkIGludG8gZnVlbCBmb3IgeW91cg0KYm9keS4gPj4+PiBodHRw
czovL2N1dHQubHkvM1Q4WjdNeA0K4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1DQpOdXZpYUdvIGlzIGEgZGVsaWNp
b3VzIHByb3RlaW4gYmFyIHdpdGggYSBjb29raWUgYW5kIGNyZWFtIGZsYXZvciBsb3Zl
ZA0KYWxsIG92ZXIgdGhlIHdvcmxkISBEdWUgdG8gdGhlIGxhcmdlIGRvc2Ugb2YgcHJv
dGVpbiBhbmQgYSBzbWFsbCBhbW91bnQNCm9mIHN1Z2FyLCB0aGlzIHByb2R1Y3QgY2Fu
IHJlcGxhY2UgYW55IG1lYWwuIE51dmlhR28gcHJvdmlkZXMgdGhlIGJvZHkNCndpdGgg
YW4gZW5lcmd5IGJvb3N0LCBoZWxwcyBidWlsZCBtdXNjbGUgbWFzcyBhbmQgYWNjZWxl
cmF0ZXMgcmVjb3ZlcnkNCmFmdGVyIHRyYWluaW5nLiBOdXZpYUdvIGJhcnMgYXJlIGNy
ZWF0ZWQgd2l0aCBwYXNzaW9uIGFuZCBpbiBoYXJtb255DQp3aXRoIG5hdHVyZS4gVGhp
cyBwcm9kdWN0IGNvbnRhaW5zIHRoZSByaWdodCBwcm9wb3J0aW9ucyBvZg0KbWFjcm9u
dXRyaWVudHMgdG8gc3RyZW5ndGhlbiB0aGUgYm9keSBhbmQgaGVscCBtYWludGFpbiBh
IGZpdC1maWd1cmUuDQpOdXZpYUdvIGJhcnMgYXJlIG5vdCBvbmx5IGEgZGVsaWNpb3Vz
LCBzd2VldCBzbmFjaywgYnV0IGFib3ZlIGFsbCBhDQpyZWFsLCB3aG9sZXNvbWUgbWVh
bCE+Pj4gaHR0cHM6Ly9jdXR0Lmx5L2tUOFhLZkUNCuKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKktQ0KUmVnYXJkcw0K
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS1DQpKdWxpYQ0KICBfX19fXyAgDQoNCg0KUmVjb3JkOiAxDQoNClRpdGxl
OglCT09LUy4gCQ0KDQpTb3VyY2U6CVByZXNlbnQgU3RhdGUgb2YgRXVyb3BlLiBKdW4x
Njk4LCBWb2wuIDkgSXNzdWUgNiwgZm9sbG93aW5nDQpwMjQ5LTI0OS4gMXAuIAkNCg0K
UHVibGljYXRpb24gVHlwZToJUGVyaW9kaWNhbAkNCg0KRG9jdW1lbnQgVHlwZToJQXJ0
aWNsZQkNCg0KU3ViamVjdHM6CVJIT0RFUywgSGVucnkNCkJPT0tTCQ0KDQpMQ0NOOglz
bjg0LTQ2MzY1CQ0KDQpBY2Nlc3Npb24gTnVtYmVyOgkzMzIzODg5MQkNCg0KUGVyc2lz
dGVudCBsaW5rIHRvIHRoaXMgcmVjb3JkIChQZXJtYWxpbmspOiANCmh0dHBzOi8vc2Vh
cmNoLmVic2NvaG9zdC5jb20vbG9naW4uYXNweD9kaXJlY3Q9dHJ1ZSZkYj1oOWgmQU49
MzMyMzg4OTEmcw0KaXRlPWVob3N0LWxpdmUNCkN1dCBhbmQgUGFzdGU6IDxhDQpocmVm
PSJodHRwczovL3NlYXJjaC5lYnNjb2hvc3QuY29tL2xvZ2luLmFzcHg/ZGlyZWN0PXRy
dWUmZGI9aDloJkFOPTMzMjMNCjg4OTEmc2l0ZT1laG9zdC1saXZlIj5CT09LUy48L2E+
DQoNCiAgX19fX18gIA0KDQpUaGUgbGluayBpbmZvcm1hdGlvbiBhYm92ZSBwcm92aWRl
cyBhIHBlcnNpc3RlbnQgbGluayB0byB0aGUgYXJ0aWNsZQ0KeW91J3ZlIHJlcXVlc3Rl
ZC4NCg0KUGVyc2lzdGVudCBsaW5rIHRvIHRoaXMgcmVjb3JkOiBGb2xsb3dpbmcgdGhl
IGxpbmsgYWJvdmUgd2lsbCBicmluZyB5b3UNCnRvIHRoZSBzdGFydCBvZiB0aGUgYXJ0
aWNsZSBvciBjaXRhdGlvbi4NCg0KQ3V0IGFuZCBQYXN0ZTogVG8gcGxhY2UgYXJ0aWNs
ZSBsaW5rcyBpbiBhbiBleHRlcm5hbCB3ZWIgZG9jdW1lbnQsDQpzaW1wbHkgY29weSBh
bmQgcGFzdGUgdGhlIEhUTUwgYWJvdmUsIHN0YXJ0aW5nIHdpdGggIjxhIGhyZWYiDQoN
CklmIHlvdSBoYXZlIGFueSBwcm9ibGVtcyBvciBxdWVzdGlvbnMsIGNvbnRhY3QgVGVj
aG5pY2FsIFN1cHBvcnQgYXQNCmh0dHA6Ly9zdXBwb3J0LmVwbmV0LmNvbS9jb250YWN0
L2Fza3VzLnBocCBvciBjYWxsIDgwMC03NTgtNTk5NS4NCg0KVGhpcyBlLW1haWwgd2Fz
IGdlbmVyYXRlZCBieSBhIHVzZXIgb2YgRUJTQ09ob3N0IHdobyBnYWluZWQgYWNjZXNz
IHZpYQ0KdGhlIE1JTklURVggTElCUkFSWSBJTkZPIE5FVFdPUksgYWNjb3VudC4gTmVp
dGhlciBFQlNDTyBub3IgTUlOSVRFWA0KTElCUkFSWSBJTkZPIE5FVFdPUksgaXMgcmVz
cG9uc2libGUgZm9yIHRoZSBjb250ZW50IG9mIHRoaXMgZS1tYWlsLg0K

